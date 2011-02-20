function getPowerInfo(adapter)
  local f = io.open("/sys/class/power_supply/"..adapter.."/present", "r")
  if f == nil then
    return "--+"
  end
  pre = f:read() f:close()
  if not pre == "1" then
    return "--+"
  end

  f = io.open("/sys/class/power_supply/"..adapter.."/status", "r")
  local sta = f:read() f:close()
  if sta:match("Full") then
    return "##"
  end

  if sta:match("Charging") then
    sta = "+"
  elseif sta:match("Discharging") then
    sta = "-" 
  end
 
  f = io.open("/sys/class/power_supply/"..adapter.."/energy_full", "r")
  local cap = f:read() f:close()
  f = io.open("/sys/class/power_supply/"..adapter.."/energy_now", "r")
  local cur = f:read() f:close()
  local battery = math.floor(cur * 100 / cap)
  if (battery < 10) then
    battery = '<span color="red">'..battery..'</span>'
  end
  return battery..sta
end

function getChargeStat()
  return getPowerInfo("BAT0")
end

