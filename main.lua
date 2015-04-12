--- config
tmr.delay(1000000)
hum="XX"
tem="XX"
-- GPIO2
PIN = 4                             
contentLength = 0   
-- user:pwassword (pimatic) in BASE64; ex. "dXNlcjpwYXNzd29yZA=="
base64login = ""   
-- pimatic server IP
pimaticServer = ""    				
interval = 300
-- send data every X seconds

--- get temp
function readDHT22()
    dht22 = require("dht22")
    dht22.read(PIN)
    t = dht22.getTemperature()
    h = dht22.getHumidity()
    hum=(h/10).."."..(h%10)
    tem=(t/10).."."..(t%10)
    print("Humidity:    "..hum.."%")
    print("Temperature: "..tem.." deg C")
    -- release module
    dht22 = nil
    package.loaded["dht22"]=nil
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
tmr.alarm(0, (interval*1000), 1, function() 
    readDHT22()
    sendData(hum, "hum")
    tmr.delay(1000000)
    sendData(tem, "tem")
end )
