<template>
  <div
    class="livespeed-overlay"
    @click="onClick"
  >
    <div class="livespeed-overlay-back" />
    <div class="livespeed-overlay-front">
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
  .livespeed-overlay {
    bottom:   0;
    left:     0;
    position: fixed;
    right:    0;
    top:      0;
    z-index:  1001;
  }

  .livespeed-overlay-back {
    background-color: rgba(0, 0, 0, 0.3);
    bottom:           0;
    left:             0;
    position:         absolute;
    right:            0;
    top:              0;
  }

  .livespeed-overlay-front {
    bottom:   0;
    left:     0;
    position: relative;
    right:    0;
    top:      0;
  }
</style>
