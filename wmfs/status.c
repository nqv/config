/*
 * Display system status.
 * To quit deamon process:
 *   $ kill -3 `cat /tmp/wmfs-st.lock`
 *
 * Author: Nguyen Quoc Viet <afelion@gmail.com>
 * License: Free
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/stat.h>

#define INTERVAL		10
#define BATT			"/sys/class/power_supply/BAT0/"
#define CPU			"/proc/stat"
#define NET_RX			"/sys/class/net/%s/statistics/rx_bytes"
#define NET_TX			"/sys/class/net/%s/statistics/tx_bytes"
#define PATH_LOCK    		"/tmp/wmfs-st.lock"
#define FLAG_EXIT		(1 << 0)
#define FLAG_DAEMON		(1 << 1)

struct cpu_t {
	unsigned int total;
	unsigned int idle;
};

struct net_t {
	unsigned long rx;
	unsigned long tx;
};

const const char *NET[] = {
	"eth0",
	"wlan0",
	NULL,
};

static char status_[128];
static struct cpu_t pcpu_ = { 0, 0 };
static int flags_ = FLAG_DAEMON;
static int lock_fd_ = 0;

static int get_time(char *str)
{
	time_t raw;
	struct tm *info;

	time(&raw);
	info = localtime(&raw);
	return strftime(str, 24, "%a %m-%d %H:%M", info);
}

static int get_batt(char *st)
{
	unsigned int full, now;
	char charge;
	FILE *f;
	char buf[32];

	/* present */
	f = fopen(BATT "present", "r");
	if (f == NULL) {
		goto no_batt;
	}
	if (fread(buf, 1, sizeof(buf), f) <= 0) {
		fclose(f);
		goto no_batt;
	}
	fclose(f);
	if (buf[0] != '1') {	/* no battery */
		goto no_batt;
	}
	/* status */
	f = fopen(BATT "status", "r");
	if (f == NULL) {
		goto no_batt;
	}
	if (fread(buf, 1, sizeof(buf), f) <= 0) {
		fclose(f);
		goto no_batt;
	}
	fclose(f);
	if (strncmp(buf, "Full", 4) == 0) {
		return sprintf(st, "##");
	}
	charge = (strncmp(buf, "Charging", 8) == 0) ? '+' : '-';
	/* capacity / current */
	f = fopen(BATT "energy_full", "r");
	if (f == NULL) {
		return 0;
	}
	fscanf(f, "%u", &full);
	fclose(f);
	f = fopen(BATT "energy_now", "r");
	if (f == NULL) {
		return 0;
	}
	fscanf(f, "%u", &now);
	fclose(f);
	return sprintf(st, "%d%c", now * 100 / full, charge);

no_batt:
	return sprintf(st, "--");
}

static int get_mem(char *st)
{
	unsigned int total, free, buffers, cached;
	FILE *f;

	f = fopen("/proc/meminfo", "r");
	if (f == NULL) {
		return 0;
	}
	fscanf(f, "%*s %u %*s\n"	/* memtotal */
		"%*s %u %*s\n"		/* memfree  */
		"%*s %u %*s\n"		/* buffers  */
		"%*s %u %*s\n",		/* cached   */
		&total, &free, &buffers, &cached);
	fclose(f);
	return sprintf(st, "%dM", (total - (free + buffers + cached)) / 1024);
}

static int read_cpu(struct cpu_t *cpu)
{
	unsigned int user, nice, sys, idle;
	FILE *f;

	f = fopen(CPU, "r");
	if (f == NULL) {
		return -1;
	}
	if (fscanf(f, "%*s %u %u %u %u", &user, &nice, &sys, &idle) != 4) {
		fclose(f);
		return -1;
	}
	cpu->total = user + nice + sys + idle;
	cpu->idle = idle;
	fclose(f);
	return 0;
}

static int get_cpu(char *st)
{
	struct cpu_t cpu;
	int total, idle, usage;

	if (pcpu_.total == 0) {
		read_cpu(&pcpu_);
		return sprintf(st, "0%%");
	}
	if (read_cpu(&cpu) < 0) {
		return sprintf(st, "?%%");
	}
	total = cpu.total - pcpu_.total;
	idle = cpu.idle - pcpu_.idle;
	usage = 100 * (total - idle) / total;
	pcpu_ = cpu;
	return sprintf(st, "%d%%", usage);
}

static int read_net(const char *iface, struct net_t *net)
{
	FILE *f;
	char path[64];
	
	/* rx */
	snprintf(path, sizeof(path), NET_RX, iface);
	f = fopen(path, "r");
	if (f == NULL) {
		return -1;
	}
	fscanf(f, "%lu", &(net->rx));
	fclose(f);
	/* tx */
	snprintf(path, sizeof(path), NET_TX, iface);
	f = fopen(path, "r");
	if (f == NULL) {
		return -2;
	}
	fscanf(f, "%lu", &(net->tx));
	fclose(f);
	return 0;
}

static int get_net(char *st)
{
	struct net_t net, total;
	int i;

	total.rx = 0;
	total.tx = 0;
	for (i = 0; NET[i] != NULL; ++i) {
		if (read_net(NET[i], &net) == 0) {
			total.rx += net.rx;
			total.tx += net.tx;
		}
	}
	return sprintf(st, "%luD %luU", total.rx / 1024, total.tx / 1024);
}

/* Record pid to lockfile */
static int lock_instance()
{
	int f;
	char buf[16];
	f = open(PATH_LOCK, O_RDWR | O_CREAT, 0644);
	if (f < 0) {
		perror("open");
		return -1;
	}
	if (lockf(f, F_TLOCK, 0) < 0) {
		close(f);
		return 0;
	}
	snprintf(buf, sizeof(buf), "%d", getpid());
	if (write(f, buf, strlen(buf)) < 0) {
		perror("write");
		close(f);
		return -1;
	}
	return f;
}

static void daemonize(void)
{
	pid_t pid, sid;

	if (getppid() == 1) {		/* Already a daemon */
		return;
	}
	pid = fork();			/* Fork off the parent process */
	if (pid < 0) {
		exit(1);
	}
	if (pid > 0) {
		exit(0);		/* Exit the parent process */
	}
	/* At this point we are executing as the child process */
	umask(0);			/* Change the file mode mask */
	sid = setsid();			/* Create a new SID for the child process */
	if (sid < 0) {
		exit(1);
	}
	lock_fd_ = lock_instance();	/* Save pid */
	if (lock_fd_ < 0) {
		exit(1);
	} else if (lock_fd_ == 0) {
		exit(0);
	}
	/* Change the current working directory */
	if (chdir("/") < 0) {
		exit(1);
	}
	/* Redirect standard files to /dev/null */
	freopen("/dev/null", "r", stdin);
	freopen("/dev/null", "w", stdout);
	freopen("/dev/null", "w", stderr);
}

static int set_status(const char *st)
{
	pid_t pid;

	pid = fork();
	if (pid < 0) {
		return -1;
	}
	if (pid == 0) {			/* child process */
		setsid();
		if (execlp("wmfs", "wmfs", "-s", st, NULL) == -1) {
					/* error */
		}
		exit(0);
	}
	return 0;
}

static void handle_sig(int sig)
{
	switch (sig) {
	case SIGQUIT:
		flags_ |= FLAG_EXIT;
		break;
	}
}

int main(int argc, char **argv)
{
	char *st;

	{	/* signal handler */
		struct sigaction act;
		sigemptyset(&act.sa_mask);
		act.sa_flags = 0;
		act.sa_handler = SIG_IGN;
		if (sigaction(SIGCHLD, &act, NULL) < 0) {
			perror("sigchld");
			return 1;
		}
		act.sa_handler = &handle_sig;
		if (sigaction(SIGQUIT, &act, NULL) < 0) {
			perror("sigint");
			return 1;
		}
	}
#if 0
	{	/* parse arguments */
		int opt;
		while ((opt = getopt(argc, argv, "d")) != -1) {
			switch (opt) {
			case 'd':	/* daemon */
				flags_ |= FLAG_DAEMON;
				break;
			}
		}
	}
#endif
	if (flags_ & FLAG_DAEMON) {
		daemonize();
	} else {
		lock_fd_ = lock_instance();
		if (lock_fd_ < 0) {
			return 1;
		} else if (lock_fd_ == 0) {
			puts("Another instance is running.");
			return 0;
		}
	}
	for (;;) {
		st = status_;
		st += get_cpu(st);
		*st++ = '|';
		st += get_mem(st);
		*st++ = '|';
		st += get_net(st);
		*st++ = '|';
		st += get_batt(st);
		*st++ = '|';
		st += get_time(st);
		set_status(status_);
		if (flags_ & FLAG_EXIT) {
			break;
		} else {
			sleep(INTERVAL);
		}
	}
	if (lock_fd_ > 0) {
		close(lock_fd_);
		unlink(PATH_LOCK);
	}
	return 0;
}
