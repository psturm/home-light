print("[server] init ..")

if srv ~= nil then srv:close() end

function render_html()
    local buf = ""

    local checked_on, checked_off = "", ""
    if led_power == 0 then
        checked_off = " checked=\"checked\""
    else
        checked_on = " checked=\"checked\""
    end        
    
    buf = buf.."<!DOCTYPE html><html><head>";
    buf = buf.."<title>ESP ambient light</title>";
    buf = buf.."<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
    buf = buf.."<style>"
    buf = buf.."body { padding: 10px; font-family: sans-serif; color: #666; }"
    buf = buf.."select { width: 100%; padding: 10px; }"
    buf = buf.."label { padding: 10px 50px 10px 5px; margin-right: 30px; }"
    buf = buf.."input[type=color] { width: 100%; height: 120px; }"
    buf = buf.."input[type=range] { width: 100%; height: 40px; }"
    buf = buf.."</style>";
    buf = buf.."</head><body><h1><a href=\"/\">ESP ambient light</a></h1><br/>";
    buf = buf.."<input type=\"radio\" name=\"power\" id=\"power_off\" value=0 onchange=\"window.location.href='?p='+this.value\""..checked_off.."> <label for=\"power_off\">OFF</label>";
    buf = buf.."<input type=\"radio\" name=\"power\" id=\"power_on\" value=1 onchange=\"window.location.href='?p='+this.value\""..checked_on.."> <label for=\"power_on\">ON</label>";
    
    if led_power == 1 then        
        buf = buf.."<br/><br/><br/>";
        
        local select_single, select_swap = "", ""
        if led_mode == "SINGLECOLOR" then
            select_single = " selected=\"selected\""
        elseif led_mode == "SWAP2COLORS" then
            select_swap = " selected=\"selected\""
        end
       
        buf = buf.."<select onchange=\"window.location.href='?m='+this.value\">"
        buf = buf.."<option value=\"SINGLECOLOR\""..select_single..">single color</option>"
        buf = buf.."<option value=\"SWAP2COLORS\""..select_swap..">phasing</option>"
        buf = buf.."</select>"
        buf = buf.."<br/><br/><br/>";

        buf = buf.."<input type=\"color\" name=\"c\" value=\"#"..led_color_base_hex.."\" onchange=\"window.location.href='?c='+this.value.replace('#', '')\">";
        if led_mode == "SWAP2COLORS" then
            local phase_duration = led_phase_duration_total / 1000
            buf = buf.."<input type=\"color\" name=\"c2\" value=\"#"..led_color_second_hex.."\" onchange=\"window.location.href='?c2='+this.value.replace('#', '')\">";
            buf = buf.."<br/><br/><br/>";
            buf = buf.."<label for=\"t\">Phase time: "..phase_duration.."s</label>"
            buf = buf.."<input type=\"range\" id=\"t\" name=\"t\" min=\"1\" max=\"120\" value=\""..phase_duration.."\" onchange=\"window.location.href='?t='+this.value\">"
        end
    end    
    buf = buf.."</body></html>";

    return buf;
end

function render_json()
    local buf = "Content-Type: application/json\n\n"
    buf = buf.."{"
    buf = buf.."\"power\": \""..led_power.."\","
    buf = buf.."\"mode\": \""..led_mode.."\","
    buf = buf.."\"color1\": \""..led_color_base_hex.."\","
    buf = buf.."\"color2\": \""..led_color_second_hex.."\","
    buf = buf.."\"time\": \""..(led_phase_duration_total/1000).."\""
    buf = buf.."}"

    return buf;
end

function _parse_get_params(_vars)
    local _params = {}
    if (_vars ~= nil) then
        for k, v in string.gmatch(_vars, "(%w+)=(%w+)&*") do
            _params[k] = v
        end
    end
    return _params
end

function update_led_from_params(params)
    if(params.m) then led_start_mode(params.m) end
    if(params.c) then led_set_base_color(params.c) end
    if(params.c2) then led_set_second_color(params.c2) end
    if(params.t) then led_set_phase_duration(params.t) end
    if (params.p) then
        if params.p == "0" then led_power_off() else led_power_on() end
    end
end


srv = net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client, request)    
        local buf = "";
        buf = buf.."HTTP/1.1 200 OK\n"
        buf = buf.."Access-Control-Allow-Origin: *\n"
        
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if (method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        
        if (path == "/favicon.ico") then 
            -- do nothing
        elseif (path == "/version") then 
            buf = buf.."Content-Type: application/json\n\n"
            buf = buf.."{\"device\": \"ESP_home_light\", \"version\": \"0.1.0\"}"
        elseif (path == "/settings") then 
            local _params = _parse_get_params(vars)
            update_led_from_params(_params)
            buf = buf..render_json();
        else        
            buf = buf.."\n"        
            local _params = _parse_get_params(vars)
            update_led_from_params(_params)            
            buf = buf..render_html();
        end
        
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
