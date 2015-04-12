--- config
-- WiFi Name
ssid = "" 
-- WiFi Password
password = ""     			


print("Setting up WIFI...")
wifi.setmode(wifi.STATION)
wifi.sta.config(ssid,password)
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function() 
if wifi.sta.getip()== nil then 
print("IP unavaiable, Waiting...") 
else 
tmr.stop(1)
print("Config done, IP is "..wifi.sta.getip())
dofile("main.lua")
end 
end)
