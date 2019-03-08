<template>
  <livespeed-overlay>
    <livespeed-text
      ref="waitingPlayersText"
      :pos="[0, -50]"
      :size="3"
    >
      {{ opponentsText }}
      <livespeed-loading-ellipsis v-show="!opponentsReady" />
    </livespeed-text>

    <livespeed-text
      :pos="[0, 22.5]"
      :size="3"
    >
      {{ t('game.setup.click_ready') }}
    </livespeed-text>
    <livespeed-button
      :pos="[0, 47.5]"
      @click="readyButtonClick"
    >
      {{ t('game.ready') }}
    </livespeed-button>
  </livespeed-overlay>
</template>

<script>
  import I18n from 'vendor/i18n-js-game.js.erb';

  export default {

    data() {
      return {
        opponentsReady: false
      };
    },
    computed: {
      opponentsText() {
        if (this.opponentsReady) {
          return I18n.t('game.setup.opponent_ready');
        } else {
          return I18n.t('game.setup.waiting');
        }
      }
    },

    methods: {
      t(name) {
        return I18n.t(name);
      },

      readyButtonClick(ev, button) {
        this.$emit('playerReady', ev, button);
        button.setDisabled(true);
      },

      setOpponentsAsReady(isReady) {
        this.opponentsReady = isReady;
      }
    }
  };
</script>
