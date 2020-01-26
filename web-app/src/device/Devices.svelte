<script>
  import { devices } from '../stores.js';
  import Device from './Device.svelte';
</script>


{#each Object.values($devices) as deviceConf, i}
  <Device deviceConf={deviceConf} />
{:else}
  <div>No devices available.</div>
{/each}

