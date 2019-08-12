<template>
  <div>
    <livespeed-overlay
      v-show="visible"
      @click="toggleMenu"
    />

    <div class="game-menu-container">
      <GameMenuButton
        :menu-opened="visible"
        @click="toggleMenu"
      />

      <div
        class="game-menu"
        :class="{ active: visible }"
      >
        <GameMenuItem :label="t('game.menu.volume')" />
        <GameMenuItem
          :label="t('game.menu.quit')"
          @click="quitClick"
        />
      </div>
    </div>
  </div>
</template>

<script>
  import GameMenuButton from 'components/game/ui/GameMenuButton';
  import GameMenuItem   from 'components/game/ui/GameMenuItem';

  export default {
    components: {
      GameMenuButton,
      GameMenuItem,
    },

    data() {
      return {
        visible: false,
      };
    },

    computed: {
      menuStyle() {
        return {
          height: this.visible ? '5rem' : 0,
        };
      },
    },

    methods: {
      toggleMenu() {
        this.visible = !this.visible;
      },

      quitClick() {
        window.location = '/matches';
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .game-menu-container {
    bottom:    0;
    left:      50%;
    position:  fixed;
    transform: translate(-50%);
    z-index:   1002;
  }

  .game-menu {
    align-items:   center;
    background:    $brand-gray-8;
    border-radius: 1rem 1rem 0 0;
    bottom:        0;
    box-shadow:    inset 0 0 10px $brand-gray-2;
    display:       flex;
    height:        0;
    padding:       0 1rem;
    position:      relative;
    overflow:      hidden;
    transition:    all 0.3s;
    z-index:       1003;

    &.active { height: 5rem; }
  }
</style>
