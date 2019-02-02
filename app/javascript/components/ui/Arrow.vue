<template>
    <livespeed-text class="livespeed-arrow" font="Arial" :pos="pos">
        <span :style="style">{{ arrowChar }}</span>
    </livespeed-text>
</template>

<script>
  export default {
    computed: {
      style() {
        return {
          transform:     'rotate(' + this.rotation + 'deg)',
          animationName: this.animationName
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
      },

      animationName() {
        switch (this.direction) {
          case 'up':
          case 'down':
            return 'livespeed-arrow-frames-vertical';
          case 'left':
          case 'right':
            return 'livespeed-arrow-frames-horizontal';
        }
      }
    },

    props: {
      pos:       { type: Array, required: true },
      direction: { type: String, default: 'up' }
    },
  };
</script>

<style lang="scss">
    .livespeed-arrow span {
        animation: livespeed-arrow-frames-vertical 0.6s infinite ease-in-out both;
        display:   inline-block;
        position:  relative;
    }

    @keyframes livespeed-arrow-frames-vertical {
        0%, 100% { top: -0.25em; }
        50% { top: 0.25em; }
    }

    @keyframes livespeed-arrow-frames-horizontal {
        0%, 100% { left: -0.25em; }
        50% { left: 0.25em; }
    }
</style>