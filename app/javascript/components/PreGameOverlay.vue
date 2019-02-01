<template>
    <livespeed-overlay>
        <livespeed-text :pos="[0, -50]" :size="3" ref="waitingPlayersText">
            Waiting for your opponent<livespeed-loading-ellipsis />
        </livespeed-text>

        <livespeed-text :pos="[0, 22.5]" :size="3">Click READY to start playing:</livespeed-text>
        <livespeed-button @click="readyButtonClick" :pos="[0, 47.5]">Ready!</livespeed-button>
    </livespeed-overlay>
</template>

<script>
    export default {
      methods: {
        readyButtonClick(ev, button) {
          this.$emit('playerReady', ev, button);
        }
      }
    }
</script>
