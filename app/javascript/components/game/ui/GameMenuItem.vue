<template>
  <button
    class="game-menu-item"
    @click="onClick"
  >
    <span class="game-menu-icon">
      {{ icon }}
    </span>
    {{ label }}
  </button>
</template>

<script>
  export default {
    props: {
      label: { type: String, required: true },
      icon:  { type: String, default: '×' }
    },

    methods: {
      onClick(ev) {
        this.$emit('click', ev);
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .game-menu-item {
    background:    transparent;
    border:        none;
    border-radius: 0.5rem;
    color:         $brand-alt-2;
    height:        4rem;
    width:         6rem;

    &:hover {
      background: rgba($brand-black, 0.2);
    }
  }

  .game-menu-item + .game-menu-item {
    margin-left: 1rem;
  }

  .game-menu-icon {
    display: block;
    font-family: Arial sans-serif;
    font-size:   2rem;
  }
</style>
