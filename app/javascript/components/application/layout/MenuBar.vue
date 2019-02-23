<template>
  <div class="menu-bar">
    <a
      href="/"
      class="menu-logo"
    >
      <img
        alt="Live Speed Logo"
        :src="require('images/logo_cards.svg')"
      >
      LiveSpeed
    </a>
    <slot name="left-menu" />

    <div class="menu-right">
      <slot name="right-menu" />
    </div>
  </div>
</template>

<script>
  export default {};
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .menu-bar {
    background:  rgba($brand-3, 0.9);
    display:     flex;
    align-items: center;
    height:      4rem;
    left:        0;
    position:    fixed;
    right:       0;
    top:         0;
    overflow:    hidden;
  }

  .menu-logo {
    color:           $brand-white;
    display:         flex;
    font-family:     'CardChars', serif;
    font-size:       1.5rem;
    height:          100%;
    align-items:     center;
    padding:         0 1rem;
    text-decoration: none;
    text-shadow:     2px 2px 4px $brand-alt-4;
    transition:      all 0.15s;

    img { height: 3rem; width: 3rem; }

    &:hover { background-color: rgba($brand-white, 0.1); }
  }

  .menu-right {
    margin-left: auto;
  }
</style>
