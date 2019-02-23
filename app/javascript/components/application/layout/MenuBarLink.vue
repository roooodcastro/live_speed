<template>
  <a
    :href="href"
    class="menu-bar-link"
    :data-method="method"
  >
    {{ label }}
  </a>
</template>

<script>
  export default {
    props: {
      active: { type: Boolean, default: false },
      href:   { type: String, default: '#' },
      label:  { type: String, required: true },
      method: { type: String, default: 'get' }
    },

    computed: {
      activeClass() {
        return this.active ? 'active' : '';
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .menu-bar-link {
    color:           $brand-white;
    display:         inline-block;
    font-size:       1.2rem;
    font-weight:     normal;
    line-height:     2rem;
    padding:         1rem 2rem;
    position:        relative;
    text-decoration: none;
    text-shadow:     1px 1px 2px $brand-alt-4;
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

      &:before { height: 0.4rem; }
    }
  }
</style>
