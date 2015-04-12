# esp8266-pimatic
Send DHT22 temperature and humidity data to pimatic server using an esp8266


Setup:

ESP8266
- Add WiFi credentials to init.lua
- Add PIN, base64login, pimaticServer to main.lua

Pimatic
- pimatic has to have two variables to be named "$esp01-hum" and "$esp01-tem"
- to show the data on the homescreen add a VariablesDevice in pimatic 
