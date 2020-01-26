dofile("wifi_conf.secret.lua")

function wifi_post_init()
    dofile("server.lua")
end

function wifi_connect_ap(ssid, pwd, ip_cfg)
    print("[WIFI] Connecting SSID="..ssid.." ..")
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid, pwd)
    wifi.sta.setip(ip_cfg)
    wifi.sta.connect()

    local time = tmr.now()
    local timeout = 30000000
    tmr.alarm(1, 1000, 1, function()
        local status = wifi.sta.status()
        if status == 5 then
            tmr.stop(1)
            ip, nm, gw = wifi.sta.getip()
            if ip == nil then
                print("[WIFI] Failed: No IP!")
            else
                print('IP=' .. ip)
                wifi_post_init()
            end
        else
            if tmr.now() - time > timeout then
                tmr.stop(1)
                print("Timeout. Stat="..status)
          end
        end
    end)
end

if (wifi.sta.status() == 5) then
    print("[WIFI] Already connected.")
    ip, nm, gw = wifi.sta.getip()
    print('IP: ' .. ip)    
    wifi_post_init()
else
    wifi_connect_ap(wifi_conf.ssid, wifi_conf.pwd, wifi_conf.ip_cfg)
end
