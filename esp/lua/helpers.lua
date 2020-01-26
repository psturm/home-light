-- converter funcs
function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end
function hex2rgb_color(hex)
    color = {}
    color.r, color.g, color.b = hex2rgb(hex)
    return color
end
function color2hex(color)
    local hex = ""
    hex = hex..('%02X'):format(tonumber(color.r))
    hex = hex..('%02X'):format(tonumber(color.g))
    hex = hex..('%02X'):format(tonumber(color.b))
    return hex
end
