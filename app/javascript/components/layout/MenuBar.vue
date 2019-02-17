<template>
  <div class="menu-bar">
    <MenuBarItem :label="'How to Play'" />
  </div>
</template>

<script>
  import MenuBarItem from 'components/layout/MenuBarLink';

  export default {
    components: { MenuBarItem }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .menu-bar {
    background: $brand-black;
    background: linear-gradient(180deg, lighten($brand-black, 5%) 0%, $brand-black 100%);
    box-shadow: 0 0 1rem $brand-black;
    height: 4rem;
  }
</style>
