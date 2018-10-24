# esp8266-pimatic
Send DHT22 or DS18B20 temperature and humidity data to pimatic server using an esp8266

![WebUI](https://raw.githubusercontent.com/Okadesde/esp8266-pimatic/master/screenshots/esp8266pimatic.png "WebUI")

Setup:

ESP8266
- Add WiFi credentials to init.lua
- Go to your esp8266 ip address and configure your client

Pimatic
- pimatic has to have two variables to be named "$esp01-hum" and "$esp01-tem"
- to show the data on the homescreen add a VariablesDevice in pimatic 


Changelog: 

07.05.2015 Added WebUI and DS18B20, updated code 
