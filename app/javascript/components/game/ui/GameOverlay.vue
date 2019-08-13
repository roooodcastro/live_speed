<template>
  <div
    class="GameOverlay"
    @click="onClick"
  >
    <div class="GameOverlay__back" />
    <div class="GameOverlay__front">
      <slot />
    </div>
  </div>
</template>

<script>
  export default {
    methods: {
      onClick(ev) {
        this.$emit('click', ev);
      },
    },
  };
</script>

<style>
  .GameOverlay {
    bottom:   0;
    left:     0;
    position: fixed;
    right:    0;
    top:      0;
    z-index:  1001;
  }

  .GameOverlay__back {
    background-color: rgba(0, 0, 0, 0.3);
    bottom:           0;
    left:             0;
    position:         absolute;
    right:            0;
    top:              0;
  }

  .GameOverlay__front {
    bottom:   0;
    left:     0;
    position: relative;
    right:    0;
    top:      0;
  }
</style>
