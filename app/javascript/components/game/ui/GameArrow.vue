<template>
  <GameText
    class="GameArrow"
    font="Arial"
    :pos="pos"
    :size="4"
  >
    <span :style="style">
      {{ arrowChar }}
    </span>
  </GameText>
</template>

<script>
  import GameText from 'components/game/ui/GameText';

  export default {
    components: {
      GameText,
    },

    props:    {
      pos:       { type: Array, required: true, },
      direction: { type: String, default: 'up', },
    },
    computed: {
      style() {
        return {
          transform:     'rotate(' + this.rotation + 'deg)',
          animationName: this.animationName,
        };
      },

      arrowChar() {
        switch (this.direction) {
          case 'up':
            return '▲';
          case 'down':
            return '▼';
          case 'left':
            return '◀';
          case 'right':
            return '▶';
        }

        return '';
      },

      animationName() {
        switch (this.direction) {
          case 'up':
          case 'down':
            return 'GameArrow--frames-vertical';
          case 'left':
          case 'right':
            return 'GameArrow--frames-horizontal';
        }

        return '';
      },
    },
  };
</script>

<style lang="scss">
  .GameArrow span {
    animation: livespeed-arrow-frames-vertical 0.6s infinite ease-in-out both;
    display:   inline-block;
    position:  relative;
  }

  @keyframes GameArrow--frames-vertical {
    0%, 100% { top: -0.25em; }
    50% { top: 0.25em; }
  }

  @keyframes GameArrow--frames-horizontal {
    0%, 100% { left: -0.25em; }
    50% { left: 0.25em; }
  }
</style>
