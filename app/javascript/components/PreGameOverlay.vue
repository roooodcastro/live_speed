<template>
  <livespeed-overlay>
    <livespeed-text
      ref="waitingPlayersText"
      :pos="[0, -50]"
      :size="3"
    >
      {{ opponentsText }}<livespeed-loading-ellipsis v-show="!opponentsReady" />
    </livespeed-text>

    <livespeed-text
      :pos="[0, 22.5]"
      :size="3"
    >
      Click READY to start playing:
    </livespeed-text>
    <livespeed-button
      :pos="[0, 47.5]"
      @click="readyButtonClick"
    >
      Ready!
    </livespeed-button>
  </livespeed-overlay>
</template>

<script>
    export default {

      data() {
        return {
          opponentsReady: false
        };
      },
      computed: {
        opponentsText() {
          if (this.opponentsReady) {
            return 'Your opponent is ready!'
          } else {
            return 'Waiting for your opponent'
          }
        }
      },

      methods: {
        readyButtonClick(ev, button) {
          this.$emit('playerReady', ev, button);
          button.setDisabled(true);
        },

        setOpponentsAsReady(isReady) {
          this.opponentsReady = isReady;
        }
      }
    }
</script>
