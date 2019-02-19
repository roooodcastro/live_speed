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
    background: rgba($brand, 0.5);
    height: 4rem;
  }
</style>
