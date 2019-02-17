<template>
  <a :href="href"
     class="menu-bar-link">
    <span>{{ label }}</span>
  </a>
</template>

<script>
  export default {
    props: {
      label: { type: String, required: true },
      href:  { type: String, default: '#' }
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

    span { display: inline-block; transition: all 0.2s; }

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

    &:after {
      background-color: $brand-alt-1;
      top:              0;
      content:          '';
      height:           0;
      left:             0;
      position:         absolute;
      right:            0;
      transition:       all 0.15s;
    }

    &:hover {
      &:before { height: 0.3rem; }

      &:after { height: 0.3rem; }

      span {
        transform: scale(1.025);
      }
    }
  }
</style>
