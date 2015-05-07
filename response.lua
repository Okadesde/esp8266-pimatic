local M = {}
local setting			

local function filter(Payload)
header={string.find(Payload,"interv=")}
if header[2]~=nil then 
    setting=string.sub(Payload,header[2]+1,#Payload) 
    if setting ~= _G.interval then
        file.open("time.lua", "w+")
        file.write(setting)
        file.flush()
        file.close()
        node.restart()
    end    
else 
    header={string.find(Payload,"pinNum=")}
    if header[2]~=nil then
        setting=string.sub(Payload,header[2]+1,#Payload)
        _G.PIN = setting
    else
        header={string.find(Payload,"device=")}
        if header[2]~=nil then
            setting=string.sub(Payload,header[2]+1,#Payload)
            _G.device = setting
        else
            header={string.find(Payload,"IPaddress=")}
            if header[2]~=nil then
                setting=string.sub(Payload,header[2]+1,#Payload)
                _G.pimaticServer = setting
            else
                header={string.find(Payload,"credent=")}
                if header[2]~=nil then
                    setting=string.sub(Payload,header[2]+1,#Payload)
                    print("typed credentials: "..setting)
                    test1 = string.gsub(setting, "+", ":")
                    print(test1)
                    ---
                    p = require("base64")
                    print(p.enc(test1))
                    _G.base64login = p.enc(setting)
                    print("encoded credentials: ".._G.base64login)
                    p = nil
                    package.loaded["base64"]=nil
                    ---
                end 
            end
        end
    end     
end
end

M.filter = filter
return M