<template>
  <GameMenuItem
    :icon-name="volumeIcon"
    :label="t(buttonLabel)"
    @click="toggleVolume"
  />
</template>

<script>
  import GameMenuItem from 'components/game/ui/GameMenuItem';
  import Cookies from 'js-cookie';

  export default {
    components: {
      GameMenuItem,
    },

    data() {
      return {
        muted: false,
      };
    },

    computed: {
      volumeIcon() {
        return this.muted ? 'volume-up' : 'volume-mute';
      },

      buttonLabel() {
        return this.muted ? 'game.menu.volume_unmute' : 'game.menu.volume_mute';
      },
    },

    mounted() {
      this.muted = Cookies.get('volumeMuted') === 'true';
    },

    methods: {
      toggleVolume() {
        this.muted = !this.muted;
        Cookies.set('volumeMuted', this.muted);
      },
    },
  };
</script>

<style lang="scss">

</style>
