function getMemActive()
  local active
  local f = io.open("/proc/meminfo", "r")
  for line in f:lines() do
    local key, value = line:match("(%w+):\ +(%d+).+")
    if key == "Active" then
      active = tonumber(value)
      break
    end
  end
  f:close()
--  return string.format("%.2f", (active / 1024))
  return string.format("%d", (active / 1024))
end

