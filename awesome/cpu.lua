local function getCpuStat()
  local cpu = {}
  local f = io.open("/proc/stat", "r")
  local line = f:read()
  f:close()
  cpu.user, cpu.nice, cpu.system, cpu.idle, cpu.iowait =
    line:match("(%d+) (%d+) (%d+) (%d+) (%d+)")
  return cpu
end

prevcpu = {}

function getCpuUsage(interval)
  local cpu = getCpuStat()
  if not prevcpu.user then
    prevcpu = cpu
  end
  local s = string.format("%02d", (cpu.user - prevcpu.user) / interval)
  prevcpu = cpu
  return s
end
