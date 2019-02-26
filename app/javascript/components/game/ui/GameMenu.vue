<template>
  <div>
    <livespeed-overlay
      v-show="visible"
      @click="toggleMenu"
    />

    <div class="game-menu-container">
      <GameMenuButton @click="toggleMenu" />

      <div
        class="game-menu"
        :style="menuStyle"
      >
        Item
      </div>
    </div>
  </div>
</template>

<script>
  import GameMenuButton from 'components/game/ui/GameMenuButton';

  export default {
    components: {
      GameMenuButton
    },

    data() {
      return {
        visible: false
      };
    },

    computed: {
      menuStyle() {
        return {
          height: this.visible ? '5rem' : 0
        };
      }
    },

    methods: {
      toggleMenu() {
        this.visible = !this.visible;
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .game-menu-container {
    bottom:   0;
    left:     0;
    position: absolute;
    right:    0;
  }

  .game-menu {
    background:    $brand-gray-8;
    border-radius: 1rem 1rem 0 0;
    bottom:        0;
    box-shadow:    inset 0 0 10px $brand-gray-2;
    left:          0;
    position:      relative;
    right:         0;
    transition:    all 0.3s;
    z-index:       1002;
  }
</style>
