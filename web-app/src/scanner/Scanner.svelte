<script>
    import Button, {Label, Icon} from '@smui/button';
	import Paper, {Title, Subtitle, Content} from '@smui/paper';
	import LinearProgress from '@smui/linear-progress';

	import getLocalIP from './ip-resolv.js';
	import { addDevice, clearAllDevices } from '../device/device-manager.js'

	let ownIP = "x.x.x.x";
	let scanInProgress = false;

	let scanCount = {
		current: 0,
		total: 5, //255,
	};


	let DeviceScanner = {
	  init: (ip) => {
		ownIP = ip;
		//DeviceScanner.scanAll();
	  },

	  updateScanCount: (shouldIncrease = false) => {
	    if (shouldIncrease == true) {
	      scanCount.current++;
	    }

	    if (scanCount.current == scanCount.total) {
		  scanInProgress = false;
		  scanCount.current = 0;
	    }
	  },


	  scanAll: () => {
		scanInProgress = true;
		clearAllDevices();

		let lastIpBlock = ownIP.substring(ownIP.lastIndexOf(".")+1);
		let baseIp = ownIP.replace(lastIpBlock, "");

		scanCount.current = 0;
		DeviceScanner.updateScanCount(false);

		//for (let i = 2; i < 255; i++) {
		for (let i = 120; i < 125; i++) {
			if (i == lastIpBlock) { continue; }
			let testIP = baseIp + i;
			DeviceScanner.scanSingleIp(testIP);
		}

	  },
	  scanSingleIp: (ip) => {
	    const scanPromise = new Promise((resolve, reject) => {
	       // HACK
		   /**
		   let timeout = Math.random() * 500;
			if (ip == "192.168.1.121") {
				setTimeout(resolve, timeout, ip);
				//resolve(ip);
			} else {
				setTimeout(reject, timeout, ip);
			}
			/**/

		  /**/
		  fetch("http://" + ip + "/version")
			.then((response) => { return response.json()})
			.then((versionJSON) => { 
				//console.log("VER", versionJSON);
				if (versionJSON.device == "ESP_home_light") {
					versionJSON.ip = ip
					resolve(versionJSON); 
				} else {
					reject(ip);
				}
			})
	        .catch((error) => { reject(ip); });
		  /**/
	    });

	    scanPromise.then((versionJSONWithIP) => {
	      //console.log("FOUND home-light device", ip);		  
		  DeviceScanner.updateScanCount(true);
		  addDevice(versionJSONWithIP);
	    }).catch((ip) => {
	      // this IP is not running a home-light
	      // console.log("Scanned, but not a home-light device", ip);
	      DeviceScanner.updateScanCount(true);
	    });
	  }
	};

	getLocalIP(DeviceScanner.init, true);
</script>

<div class="device-scan-box">
<Paper>
  <Title>Device scan</Title>  
  <p>
	You can scan the local network for home-light devices (scans last IP block 1-254).
  </p>
  <p>
	Your IP: {ownIP}
  </p>
  <Content>

		<Button on:click={DeviceScanner.scanAll} disabled='{scanInProgress}'>
		  <Icon class="material-icons">settings_remote</Icon>
		  <Label>Scan for devices</Label>
		</Button>

		{#if scanInProgress}
		    <div>Scanning .. {scanCount.current}/{scanCount.total}</div>
			<LinearProgress indeterminate />
		{/if}

	</Content>
</Paper>
</div>


<style>
.device-scan-box {
	margin-top: 20px;
}
</style>