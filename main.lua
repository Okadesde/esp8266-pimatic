print("test")
--- config
tmr.delay(1000000)
hum = 0
tem = 0
_G.PIN = 4                              -- GPIO2
contentLength = 0                   
_G.base64login = ""                     -- user:pwassword (pimatic) in BASE64
_G.pimaticServer = "192.168.178.1"      -- pimatic server IP

file.open("time.lua", "r")
_G.interval = file.readline()           -- send data every X seconds
file.close()

_G.device = "DHT22"

-- site
function site()
    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(conn, payload) 
            print("Payload received: "..payload)
            
            response = require("response")
            response.filter(payload)
            -- release module
            response = nil
            package.loaded["response"]=nil
            
            conn:send('HTTP/1.1 200 OK\n\n')
            conn:send('<!DOCTYPE HTML>\n')
            conn:send('<html>\n')
            conn:send('<head><meta  content="text/html; charset=utf-8">\n')
            conn:send('<title>ESP8266</title></head>\n') 
            conn:send('<body><h1>ESP8266 pimatic client</h1>\n')
            conn:send('<hr>\n')
            conn:send('<p>Pimatic Server Credentials:</p>')
            conn:send('<form action="" method="POST">\n')
            conn:send('<input type="text" placeholder="username password" name="credent">')
            conn:send('<input type="submit" value="credent">')
            conn:send('</form>')
            conn:send('<hr>\n')
            conn:send('<form action="" method="POST">\n')
            conn:send('<p>Pimatic Server IP Address:</p>')
            conn:send('<input type="text" placeholder="xxx.xxx.xxx.xxx" name="IPaddress">')
            conn:send('<input type="submit" value="IPaddress">')
            conn:send('</form>')
            conn:send('<hr>\n')
            conn:send('<p>How often should your ESP8266 send data:</p>')
            conn:send('<form action="" method="POST">\n')
            conn:send('<input type="submit" name="interv" value="30">\n')
            conn:send('<input type="submit" name="interv" value="60">\n')
            conn:send('<input type="submit" name="interv" value="180">\n')
            conn:send('<input type="submit" name="interv" value="300">\n')
            conn:send('<hr>\n')
            conn:send('<p>Data PIN:</p>')
            conn:send('<input type="submit" name="pinNum" value="3">\n')
            conn:send('<input type="submit" name="pinNum" value="4">\n')
            conn:send('<hr>\n')
            conn:send('<p>Device connected:</p>')
            conn:send('<input type="submit" name="device" value="DS18B20">\n')
            conn:send('<input type="submit" name="device" value="DHT22">\n')
            conn:send('</form>')
            conn:send('<hr>\n')
            conn:send('<hr>\n')
            conn:send('<p>Current Configuration:</p>')
            conn:send('<p>Interval: '..interval..'</p>')
            conn:send('<p>Data PIN: '..PIN..'</p>')
            conn:send('<p>Device: '..device..'</p>')
            conn:send('<p>Pimatic IP: '..pimaticServer..'</p>')
            conn:send('</body></html>\n')
            conn:on("sent",function(conn) conn:close() end)
        end)
    end)    
end

--- calc content-length
function calcLength(type)
    print(type)
    contentLength = string.len(type) + 40
    print("Content-Length: "..contentLength) 
end
--- send data
function sendData(type, name)
    calcLength(type)
    print("Sending data ...")
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", function(conn, payload) print(payload) end)
    conn:connect(80,pimaticServer)
    conn:send("PATCH /api/variables/esp01-"..name.." HTTP/1.1\r\n")
    conn:send("Authorization: Basic "..base64login.."\r\n")
    conn:send("Host: "..pimaticServer.."\r\n")
    conn:send("Content-Type:application/json\r\n")
    conn:send("Content-Length: "..contentLength.."\r\n\r\n")
    conn:send("\{\"type\"\: \"value\"\, \"valueOrExpression\"\: "..type.."\}")
    ---
    conn:on("sent",function(conn)
        print("Closing connection")
        conn:close()
    end)
    conn:on("disconnection", function(conn)
        print("Got disconnection...")
    end)
---
end
--- main loop 
site()

tmr.alarm(0, (interval*1000), 1, function() 
    t = require("temperature")
    t.read(PIN,device)
    tem = t.getTemperature()
    hum = t.getHumidity()
    t = nil
    package.loaded["temperature"] = nil
    
    sendData(hum, "hum")
    tmr.delay(1000000)
    sendData(tem, "tem")
end )
