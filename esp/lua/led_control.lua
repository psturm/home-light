led_color_base_hex = "0000ff"
led_color_second_hex = "ffffff"
led_phase_duration_total = 10000
led_power = 0 
led_mode = "SINGLECOLOR"

_led_color_phase_hex = "ffffff"
_led_timer_swap = 1

function led_power_on()
    led_power = 1
    _led_start_current_mode()
end

function led_power_off()
    led_power = 0
    _led_fill_all({r=0,g=0,b=0})
    tmr.stop(_led_timer_swap)
end

function led_get_mode()
    local _cfg = {color=led_color_base_hex, second_color=led_color_second_hex}
    return led_mode, _cfg
end

function led_start_mode(mode_new)
    led_mode = mode_new
    _led_start_current_mode()
end

function _led_start_current_mode()
    -- reset
    _led_fill_all({r=0,g=0,b=0})
    tmr.stop(_led_timer_swap)
    
    if led_mode == "SINGLECOLOR" then
        _led_start_single()
    elseif led_mode == "SWAP2COLORS" then
        _led_start_swp2colors()
    else
        print("Unknown mode:", led_mode)
    end
end

function led_set_base_color(hex)
    led_color_base_hex = hex
    if led_power == 1 then _led_start_current_mode() end
end
function led_set_second_color(hex)
    led_color_second_hex = hex
    if led_power == 1 then _led_start_current_mode() end
end
function led_set_phase_duration(seconds)
    led_phase_duration_total = seconds * 1000
    if led_power == 1 then _led_start_current_mode() end
end

function _led_fill_all(color)
    led_buffer:fill(color.g, color.r, color.b)
    ws2812.write(led_buffer)
end

function _led_start_single()
    -- print("Starting SINGLECOLOR .., led_color_base_hex)
    _led_fill_all(hex2rgb_color(led_color_base_hex))
end

function _led_start_swp2colors()    
    phase_duration_step = 50
    phase_step_count = math.floor(led_phase_duration_total / phase_duration_step)
    phase_direction = 1

    color_base = hex2rgb_color(led_color_base_hex)
    color_second = hex2rgb_color(led_color_second_hex)

    shift_r = (color_base.r - color_second.r) * -1 / phase_step_count
    shift_g = (color_base.g - color_second.g) * -1 / phase_step_count
    shift_b = (color_base.b - color_second.b) * -1 / phase_step_count

    _led_color_phase_hex= led_color_base_hex; 
    local step = 1
    tmr.alarm(_led_timer_swap, phase_duration_step, 1, function()
        local col = hex2rgb_color(_led_color_phase_hex)

        col.r = col.r + shift_r*step
        col.g = col.g + shift_g*step
        col.b = col.b + shift_b*step
        
        _led_fill_all(col)

        if step >= phase_step_count then phase_direction = -1 elseif step <= 1 then phase_direction = 1 end
        step = step + phase_direction
    end)
    
end


led_power_on()
