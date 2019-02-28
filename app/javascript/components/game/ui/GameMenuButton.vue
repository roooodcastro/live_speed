<template>
  <div
    class="game-menu-button"
    :class="{ active: menuOpened }"
    @click="onClick"
  >
    . . .
  </div>
</template>

<script>
  export default {
    props: {
      menuOpened: { type: Boolean, required: true }
    },

    methods: {
      onClick(ev) {
        this.$emit('click', ev);
      }
    }
  };
</script>

<style lang="scss">
  .game-menu-button {
    background-color: #CCD0CD;
    border-radius:    1rem 1rem 0 0;
    bottom:           -5rem;
    box-shadow:       inset 0 -2px 10px #344339;
    color:            white;
    font-size:        2rem;
    height:           1rem;
    left:             calc(50% - 5rem);
    line-height:      0;
    position:         relative;
    text-align:       center;
    text-shadow:      1px 1px 2px #344339;
    transition:       all 0.3s;
    width:            10rem;
    z-index:          1002;

    &:hover {
      cursor: pointer;
      height: 1.5rem;
    }

    &.active {
      height: 1.5rem;
      bottom: 0;
    }
  }
</style>
