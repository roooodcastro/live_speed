<template>
  <div
    class="alert"
    :class="cssClass"
  >
    <strong>{{ title }}</strong>
    {{ content }}
  </div>
</template>

<script>
  export default {
    props: {
      content: { type: String, default: null, },
      title:   { type: String, default: null, },
      type:    { type: String, default: 'notice', },
    },

    computed: {
      cssClass() {
        return 'alert-' + this.type;
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .alert {
    background:    $brand-white;
    border-radius: 0.5rem;
    color:         $text-color;
    margin-top:    1rem;
    min-width:     20rem;
    padding:       1rem 2rem;
    position:      relative;

    &:before {
      background:    $brand-gray-5;
      border-radius: 0.5rem;
      bottom:        -0.2rem;
      box-shadow:    0 0.2rem 0.5rem $brand-black;
      content:       '';
      left:          0;
      position:      absolute;
      right:         0;
      top:           0;
      z-index:       -1;
    }

    strong {
      color:   $brand-black;
      display: block;
    }
  }

  .alert-notice {
    strong { color: $brand; }

    &:before { background: $brand; }
  }

  .alert-warning {
    strong { color: $yellow; }

    &:before { background: $yellow; }
  }

  .alert-error {
    strong { color: $red; }

    &:before { background: $red; }
  }
</style>
