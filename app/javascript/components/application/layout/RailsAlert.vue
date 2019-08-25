<template>
  <div
    class="RailsAlert"
    :class="cssClass"
  >
    <div>
      <strong v-if="title">{{ title }}:</strong>
      {{ content }}
    </div>
    <CloseButton
      class="RailsAlert__close-button"
      @close="$emit('close')"
    />
  </div>
</template>

<script>
  import CloseButton from 'components/application/layout/CloseButton';

  export default {
    components: {
      CloseButton,
    },

    props: {
      content: { type: String, default: null, },
      title:   { type: String, default: null, },
      type:    { type: String, default: 'notice', },
    },

    computed: {
      cssClass() {
        return 'RailsAlert--' + this.type;
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .RailsAlert {
    background:      $brand-white;
    border-radius:   0.25rem;
    color:           $text-color;
    display:         flex;
    justify-content: space-between;
    margin-top:      1rem;
    padding:         0 0.5rem;
    position:        relative;
    width:           100%;

    div {
      padding:        1rem 2rem;
      display:        flex;
      flex-direction: row;
    }

    &:before {
      background:    $brand-gray-5;
      border-radius: 0.25rem;
      bottom:        -0.4rem;
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
      margin-right: 1rem;
    }
  }

  .RailsAlert--notice {
    strong { color: $brand; }

    &:before { background: $brand; }
  }

  .RailsAlert--warning {
    strong { color: $yellow; }

    &:before { background: $yellow; }
  }

  .RailsAlert--error {
    strong { color: $red; }

    &:before { background: $red; }
  }

  .RailsAlert__close-button {
    align-self: center;
  }
</style>
