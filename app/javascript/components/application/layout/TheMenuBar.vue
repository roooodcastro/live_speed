<template>
  <div class="TheMenuBar">
    <a
      href="/"
      class="TheMenuBar__logo"
    >
      <img
        :alt="t('logo_alt')"
        :src="require('images/logo_cards.svg')"
      >
      <span>{{ 'title' | i18n }}</span>
    </a>

    <MenuBarLink
      v-for="menuLink in menu.left"
      :key="menuLink.href"
      v-bind="menuLink"
    />

    <div class="TheMenuBar__right">
      <MenuBarLink
        v-for="menuLink in menu.right"
        :key="menuLink.href"
        v-bind="menuLink"
      />
    </div>
  </div>
</template>

<script>
  import MenuBarLink from 'components/application/layout/MenuBarLink';

  export default {
    components: {
      MenuBarLink,
    },

    props: {
      menu: {
        type:     Object,
        required: true,
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .TheMenuBar {
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

  .TheMenuBar__logo {
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

    &:hover {
      background-color: rgba($brand-white, 0.1);
      color: $brand-white;
    }
  }

  .TheMenuBar__right {
    margin-left: auto;
    height: 100%;
  }
</style>
