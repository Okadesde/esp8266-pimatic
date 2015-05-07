local M = {}

local humi = 0
local temp = 0
local t = 0
local h = 0 
 
function read(PIN,DEVICE)
    if DEVICE == "DHT22" then
        dht22 = require("dht22")
        dht22.read(PIN)
        t = dht22.getTemperature()
        h = dht22.getHumidity()
        humi=(h/10).."."..(h%10)
        temp=(t/10).."."..(t%10)
        print("Humidity:    "..humi.."%")
        print("Temperature: "..temp.." deg C")
        -- release module
        dht22 = nil
        package.loaded["dht22"]=nil
    else
        ds18 = require("ds18b20")
        ds18.setup(PIN)
        temp = ds18.read()
        print("Temperature:     "..temp.." deg C")
        --release module
        ds18 = nil
        ds18b20 = nil
        package.loaded["ds18b20"]=nil
    end
end
--- get data
function getTemperature()
  return temp
end

function getHumidity()
  return humi
end

M.read = read
M.getTemperature = getTemperature
M.getHumidity = getHumidity

return M