import { writable } from 'svelte/store';


let devices_default = {};

const queryParams = window.location.search;
if (queryParams.includes("debug")) {
    devices_default = {
        "23.42.5.5": {
            "ip": "23.42.5.5",
            "settings": {            
                "power": "1",
                "mode": "SWAP2COLORS",
                "color1": "0000ff",
                "color2": "ff0606",
                "time": "10"
            },
            "version": "0.1-debug",
        },
        "5.5.5.23": {
            "ip": "5.5.5.23",
            "settings": {            
                "power": "1",
                "mode": "SINGLECOLOR",
                "color1": "ff6600",
                "color2": "000000",
                "time": "1"
            },
            "version": "0.1-debug",
        },
        "1.2.3.4": {
            "ip": "1.2.3.4",
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