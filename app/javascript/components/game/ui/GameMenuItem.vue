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
    font-family:   'CardChars', 'Barbaro', serif;
    font-size:     0.9rem;
    height:        4rem;
    width:         8rem;

    &:hover {
      background: rgba($brand-black, 0.2);
      color:      $brand-alt;
      cursor:     pointer;
    }
  }

  .game-menu-item + .game-menu-item {
    margin-left: 1rem;
  }

  .game-menu-icon {
    display:     block;
    font-family: Arial sans-serif;
    font-size:   2rem;
  }
</style>
