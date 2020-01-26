local boot_delay = 10 -- in sec

function init_real()
    tmr.stop(0)
    init_main()
end


dofile("init_main.lua")
init_boot()

tmr.alarm(0, boot_delay*1000, 0, function() init_real() end)
print("Boot delay ("..boot_delay.."s) ..")
