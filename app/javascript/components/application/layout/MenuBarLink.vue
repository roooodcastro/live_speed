<template>
  <a
    :href="href"
    class="MenuBarLink"
    :data-method="method"
  >
    {{ label }}
  </a>
</template>

<script>
  export default {
    props: {
      active: { type: Boolean, default: false, },
      href:   { type: String, default: '#', },
      label:  { type: String, required: true, },
      method: { type: String, default: 'get', },
    },

    computed: {
      activeClass() {
        return this.active ? 'active' : '';
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .MenuBarLink {
    color:           $brand-white;
    display:         flex;
    flex-direction:  column;
    font-size:       $menu-bar-height / 3;
    font-weight:     normal;
    height:          100%;
    justify-content: center;
    padding:         0 2rem;
    position:        relative;
    text-decoration: none;
    text-shadow:     1px 1px 0 $brand-alt-4;
    transition:      all 0.15s;

    &:before {
      background-color: $brand-alt-1;
      bottom:           0;
      content:          '';
      height:           0;
      left:             0;
      position:         absolute;
      right:            0;
      transition:       all 0.15s;
    }

    &:hover {
      background-color: rgba($brand-white, 0.1);
      color: $brand-white;

      &:before { height: $menu-bar-height / 10; }
    }
  }

  @media (max-width: 575px) {
    .MenuBarLink {
      padding: 0 0.5rem;
    }
  }
</style>
