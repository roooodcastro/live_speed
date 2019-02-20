<template>
  <div class="menu-bar">
    <slot />
  </div>
</template>

<script>
  export default {};
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .menu-bar {
    background: rgba($brand, 0.2);
    height: 4rem;
  }
</style>
