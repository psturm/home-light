<script>
  import { devices } from '../stores.js';

  import Card, {Content, PrimaryAction, Media, MediaContent, Actions, ActionButtons, ActionIcons} from '@smui/card';
  import Button, {Label} from '@smui/button';
  import IconButton, {Icon} from '@smui/icon-button';
  import LinearProgress from '@smui/linear-progress';

  import { createDevice } from './device-manager.js'

  export let deviceConf = createDevice({ip:"0.0.0.0", version:"load"});
  
  let modes = [
		{ val: "SINGLECOLOR", text: `Single color` },
		{ val: "SWAP2COLORS", text: `Color phasing` }
	];

  function sendSettings() {
	  let url = "http://" + deviceConf.ip + "/settings"
	  url += "?p=" + deviceConf.settings.power
	  url += "&c=" + deviceConf.settings.color1
	  url += "&c2=" + deviceConf.settings.color2
	  url += "&m=" + deviceConf.settings.mode
	  url += "&t=" + deviceConf.settings.time
	  fetch(url)
		.then((response) => { return response.json()})
		.then((settingsNew) => { console.log("settingsNew", settingsNew); })
  }

  function togglePower(ev) {
	  deviceConf.settings.power = deviceConf.settings.power == "0" ? "1" : "0";
	  sendSettings();
  }
  function setMode(ev) {
	  deviceConf.settings.mode = ev.target.value;
	  sendSettings();
  }
  function setBaseColor(ev) {
	  deviceConf.settings.color1 = ev.target.value.replace("#", "");
	  sendSettings();
  }
  function setSecondColor(ev) {
	  deviceConf.settings.color2 = ev.target.value.replace("#", "");
	  sendSettings();
  }
  function setPhaseTime(ev) {
	  deviceConf.settings.time = ev.target.value;
	  sendSettings();
  }
</script>

<div class="device-card">
<Card>	
  <PrimaryAction on:click={() => togglePower()}>
	{#if deviceConf.settings.mode == "SWAP2COLORS" }
	<Media style="background: linear-gradient(90deg, #{deviceConf.settings.color1} 0%, #{deviceConf.settings.color2} 100%);"><br/><br/></Media>
	{:else}
	<Media style="background-color: #{deviceConf.settings.color1}"><br/><br/></Media>
	{/if}
</PrimaryAction>
	<Content class="mdc-typography--body2">
		<h2 class="mdc-typography--headline6" style="margin: 0;">
			{#if deviceConf.settings.power == "1" }
				<Icon class="material-icons" style="color: orange;">emoji_objects</Icon>
			{:else}
				<Icon class="material-icons">emoji_objects</Icon>
			{/if}
			IP: {deviceConf.ip}
		</h2>
		{#if deviceConf.settings.power == "1"}

			<br/>
			<h3 class="mdc-typography--subtitle2" style="margin: 0 0 10px; color: #888;">
				<select on:change="{setMode}" class="mode-select">
					{#each modes as mode}
						<option value={mode.val} selected={deviceConf.settings.mode == mode.val}>
							{mode.text}
						</option>
					{/each}
				</select>
			</h3>		

			{#if deviceConf.version == "load"}
				<div>Loading settings ..</div>
				<LinearProgress indeterminate />
			{:else}
				<input type="color" value="#{deviceConf.settings.color1}" name="c" class="colorpicker" on:change="{setBaseColor}"/>
				{#if deviceConf.settings.mode == "SWAP2COLORS" }
					<input type="color" value="#{deviceConf.settings.color2}" name="c2" class="colorpicker" on:change="{setSecondColor}"/>
					<br/><br/>
					<div>
						<Icon class="material-icons">watch_later</Icon>
						Phase time: {deviceConf.settings.time}s
						<br/>
						<input type="range" value="{deviceConf.settings.time}" min="1" max="120" on:change="{setPhaseTime}"/>
					</div>
				{/if}
			{/if}
		{/if}

		<div class="device-card-footer">
			<div>Version: {deviceConf.version}</div>
		</div>
	</Content>
</Card>
</div>

<br/>



<style>
.mode-select {
	width: 100%;
}
input[type=color] {
	width: 49%;
	height: 70px;
}
input[type=range] {
	width: 100%;
	height: 30px;
}

.device-card-footer {
	margin-top: 10px;
	color: #999;
	font-size: .8em;
}
</style>