/*
 * Print system status.
 */

#include <stdio.h>
#include <time.h>
#include <string.h>

static char status_[128];
static char buf_[128];
static FILE *f_;

static int get_time(char *str)
{
	time_t raw;
	struct tm *info;

	time(&raw);
	info = localtime(&raw);
	return strftime(str, 24, "%a %Y-%m-%d %H:%M", info);
}

#define BATT	"/sys/class/power_supply/BAT0/"
static int get_batt(char *st)
{
	unsigned int full, now;
	char charge;
	/* present */
	f_ = fopen(BATT "present", "r");
	if (f_ == NULL) {
		return 0;
	}
	if (fread(buf_, 1, sizeof(buf_), f_) <= 0) {
		goto err;
	}
	fclose(f_);
	if (buf_[0] != '1') {	/* no battery */
		return sprintf(st, "--");
	}
	/* status */
	f_ = fopen(BATT "status", "r");
	if (f_ == NULL) {
		return 0;
	}
	if (fread(buf_, 1, sizeof(buf_), f_) <= 0) {
		goto err;
	}
	fclose(f_);
	if (strncmp(buf_, "Full", 4) == 0) {
		return sprintf(st, "##");
	}
	charge = (strncmp(buf_, "Charging", 8) == 0) ? '+' : '-';
	/* capacity / current */
	f_ = fopen(BATT "energy_full", "r");
	if (f_ == NULL) {
		return 0;
	}
	fscanf(f_, "%u", &full);
	fclose(f_);
	f_ = fopen(BATT "energy_now", "r");
	if (f_ == NULL) {
		return 0;
	}
	fscanf(f_, "%u", &now);
	fclose(f_);
	return sprintf(st, "%d%c", now * 100 / full, charge);
err:
	fclose(f_);
	return 0;
}

static int get_mem(char *st)
{
	unsigned int total, free, buffers, cached;

	f_ = fopen("/proc/meminfo", "r");
	if (f_ == NULL) {
		return 0;
	}
	fscanf(f_, "%*s %u %*s\n"	/* memtotal */
		"%*s %u %*s\n"		/* memfree  */
		"%*s %u %*s\n"		/* buffers  */
		"%*s %u %*s\n",		/* cached   */
		&total, &free, &buffers, &cached);
	fclose(f_);
	return sprintf(st, "%dM", (total - (free + buffers + cached)) / 1024);
}

#define CPU_CACHE_FILE		"/tmp/cpustat.wmfs"
struct cpu_t {
	unsigned int user;
	unsigned int nice;
	unsigned int sys;
	unsigned int idle;
};

static int read_cpu(struct cpu_t *cpu, int cache)
{
	f_ = fopen(cache ? CPU_CACHE_FILE : "/proc/stat", "r");
	if (f_ == NULL) {
		return -1;
	}
	fscanf(f_, "%*s %u %u %u %u",
		&cpu->user, &cpu->nice, &cpu->sys, &cpu->idle);
	fclose(f_);
	return 0;
}

static void save_cpu(struct cpu_t *cpu)
{
	f_ = fopen(CPU_CACHE_FILE, "w");
	if (f_ == NULL) {
		return;
	}
	fprintf(f_, "cpu %u %u %u %u\n",
		cpu->user, cpu->nice, cpu->sys, cpu->idle);
	fclose(f_);
}

static int get_cpu(char *st)
{
	struct cpu_t pcpu, cpu;
	int load;

	if (read_cpu(&pcpu, 1) < 0) {
		read_cpu(&cpu, 0);
		save_cpu(&cpu);
		return sprintf(st, "?%%");
	}
	read_cpu(&cpu, 0);
	save_cpu(&cpu);

	cpu.user += cpu.sys - (pcpu.user + pcpu.sys);
	cpu.idle -= pcpu.idle;
	load = cpu.user + cpu.idle;
	if (load != 0) {
		load = cpu.user * 100 / load;
	} else {
		load = 100;
	}
	return sprintf(st, "%d%%", load);
}

int main(int argc, char **argv)
{
	char *st = status_;

	st += get_cpu(st);
	*st++ = '|';
	st += get_mem(st);
	*st++ = '|';
	st += get_batt(st);
	*st++ = '|';
	st += get_time(st);
	puts(status_);
	return 0;
}
