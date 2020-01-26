-- CONFIG -------------------------------
LED_COUNT = 60
BYTES_PER_LED = 3
-----------------------------------------

print("[INIT] WS2812 ("..LED_COUNT.." LEDs) ..")
ws2812.init()
led_buffer = ws2812.newBuffer(LED_COUNT, BYTES_PER_LED)
led_buffer:fill(0, 0, 0)
ws2812.write(led_buffer)
