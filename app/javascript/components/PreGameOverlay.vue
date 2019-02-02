<template>
    <livespeed-overlay>
        <livespeed-text :pos="[0, -50]" :size="3" ref="waitingPlayersText">
            {{ opponentsText }}<livespeed-loading-ellipsis v-show="!opponentsReady" />
        </livespeed-text>

        <livespeed-text :pos="[0, 22.5]" :size="3">Click READY to start playing:</livespeed-text>
        <livespeed-button @click="readyButtonClick" :pos="[0, 47.5]">Ready!</livespeed-button>
    </livespeed-overlay>
</template>

<script>
    export default {
      computed: {
        opponentsText() {
          if (this.opponentsReady) {
            return 'Your opponent is ready!'
          } else {
            return 'Waiting for your opponent'
          }
        }
      },

      data() {
        return {
          opponentsReady: false
        };
      },

      methods: {
        readyButtonClick(ev, button) {
          this.$emit('playerReady', ev, button);
        },

        setOpponentsAsReady(isReady) {
          this.opponentsReady = isReady;
        }
      }
    }
</script>
