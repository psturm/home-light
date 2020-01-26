
function init_boot()
    print("[INIT] Boot ..")
    dofile("init_ws2812.lua")
    dofile("helpers.lua")
end

function init_main()
    print("[INIT] MAIN ..")
    dofile("led_control.lua")
    dofile("wifi.lua")
end
