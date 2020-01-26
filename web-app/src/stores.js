import { writable } from 'svelte/store';


let devices_default = {};

const queryParams = window.location.search;
if (queryParams.includes("debug")) {
    devices_default = {
        "192.168.0.123": {
            "ip": "192.168.0.123",
            "settings": {            
                "power": "1",
                "mode": "SWAP2COLORS",
                "color1": "0000ff",
                "color2": "ff0606",
                "time": "10"
            },
            "version": "0.1-debug",
        },
        "192.168.1.213": {
            "ip": "192.168.1.213",
            "settings": {            
                "power": "1",
                "mode": "SINGLECOLOR",
                "color1": "ff6600",
                "color2": "000000",
                "time": "1"
            },
            "version": "0.1-debug",
        },
        "192.168.4.23": {
            "ip": "192.168.4.23",
            "settings": {            
                "power": "0",
                "mode": "SINGLECOLOR",
                "color1": "ff6600",
                "color2": "000000",
                "time": "1"
            },
            "version": "0.1-debug",
        }
    };
}


export const devices = writable(devices_default);