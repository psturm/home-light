import { devices } from '../stores.js';


let _devices;
const _devices_subscription = devices.subscribe(value => {
    _devices = value;
});

export const clearAllDevices = () => {
    devices.set({});
}

export const addDevice = (versionJSONWithIP) => {    
    let devices_existing = _devices;
    let device_new = createDevice(versionJSONWithIP);
    console.log("Adding device", device_new);
    devices_existing[versionJSONWithIP.ip] = device_new;

    devices.set(devices_existing);
    fetchSettings(versionJSONWithIP.ip);
}


const fetchSettings = (ip) => {
    fetch("http://" + ip + "/settings")
    .then((response) => {
        return response.json();
    })
    .then((settingsJson) => {
        let devices_existing = _devices;
        devices_existing[ip]["settings"] = settingsJson;
        devices.set(devices_existing);
    })
    /*.catch((error) => {
        alert("Unable to fetch settings for device", ip);
    })*/;
}

export const createDevice = (versionJSONWithIP) => {
    return {
        ip: versionJSONWithIP.ip,
        settings: {
            mode: null,
            power: null,
            color1: null,
            color2: null,
            time: null,
        },
        version: versionJSONWithIP.version,
    };
}
