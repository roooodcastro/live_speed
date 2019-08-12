<template>
  <div class="MenuBar">
    <a
      href="/"
      class="MenuBar__logo"
    >
      <img
        :alt="t('logo_alt')"
        :src="require('images/logo_cards.svg')"
      >
      {{ 'title' | i18n }}
    </a>
    <slot name="left-menu" />

    <div class="MenuBar__right">
      <slot name="right-menu" />
    </div>
  </div>
</template>

<script>
  export default {
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .MenuBar {
    background:  rgba($brand-3, 0.9);
    display:     flex;
    align-items: center;
    height:      $menu-bar-height;
    left:        0;
    position:    fixed;
    right:       0;
    top:         0;
    overflow:    hidden;
  }

  .MenuBar__logo {
    color:           $brand-white;
    display:         flex;
    font-family:     'CardChars', serif;
    font-size:       $menu-bar-height / 2.5;
    height:          100%;
    align-items:     center;
    padding:         0 1rem;
    text-decoration: none;
    text-shadow:     2px 2px 4px $brand-alt-4;
    transition:      all 0.15s;

    img { height: $menu-bar-height - 0.5rem; width: $menu-bar-height - 0.5rem; }

    &:hover { background-color: rgba($brand-white, 0.1); }
  }

  .MenuBar__right {
    margin-left: auto;
  }
</style>
