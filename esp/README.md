# Home Light Device



### Setup

pip install esptool

esptool.py --port /dev/ttyUSB0  write_flash 0x00000 /home/riel/Downloads/nodemcu-1.5.4.1-final-13-modules-2019-12-28-14-31-55-float.bin


WS28128 LED strip DATA_in on D4 on dev board (GPIO2)



### LED strip

SK6812 / WS2812

20mA * 60 LEDs = 1.2A


> Stromaufnahme: max. 20mA/Kanal pro LED - Ruhestrom ca. 1mA pro LED - PWM: 8 bit/Kanal - Daten-Übertragungsrate : 8kbps - Verpackung: ESD geschützt - RoHS: ja

e.g. 
* https://www.led-genial.de/SK6812-RGB-LED-Strip-30-LEDs-Meter-Schwarz
* https://www.amazon.de/gp/product/B00S1AMV3U/ref=ppx_yo_dt_b_asin_title_o00_s01?ie=UTF8&psc=1



### web links

* Uploader - https://github.com/andidittrich/NodeMCU-Tool