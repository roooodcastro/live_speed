<template>
  <div class="menu-bar">
    <a
      href="/"
      class="menu-logo"
    >
      <img
        alt="Live Speed Logo"
        :src="require('images/logo_text.svg')"
      >
    </a>
    <slot />
  </div>
</template>

<script>
  export default {};
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .menu-bar {
    background:  rgba($brand, 0.4);
    display:     flex;
    align-items: center;
    height:      4rem;
  }

  .menu-logo {
    display:     flex;
    height:      100%;
    align-items: center;
    padding:     0 1rem;
    transition:  all 0.15s;

    img { height: 3rem; width: 10rem; }

    &:hover { background-color: rgba($brand-white, 0.1); }
  }
</style>
