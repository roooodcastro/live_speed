<template>
  <a
    :href="href"
    class="menu-bar-link"
  >
    {{ label }}
  </a>
</template>

<script>
  export default {
    props: {
      active: { type: Boolean, default: false },
      href:   { type: String, default: '#' },
      label:  { type: String, required: true }
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

    &:hover:before { height: 0.4rem; }
  }
</style>
