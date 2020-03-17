<template>
  <div
    class="RailsAlert"
    :class="cssClass"
  >
    <div>
      <strong v-if="title">{{ title }}</strong>
      {{ content }}
    </div>

    <CloseButton
      v-if="closeable"
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
      content:   { type: String, default: null, },
      title:     { type: String, default: null, },
      type:      { type: String, default: 'notice', },
      closeable: { type: Boolean, default: true, },
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
    background:          $brand-white;
    border:              1px solid black;
    border-bottom-width: 0.4rem;
    border-radius:       0.25rem;
    color:               $text-color;
    display:             flex;
    justify-content:     space-between;
    margin-top:          1rem;
    padding:             0 0.5rem;
    width:               100%;

    div {
      padding:        1rem 2rem;
      display:        flex;
      flex-direction: row;
    }

    strong {
      color:        $brand-black;
      margin-right: 1rem;
    }
  }

  .RailsAlert--notice {
    background-color: lighten($green, 75%);
    border-color:     $green;

    strong { color: $green; }
  }

  .RailsAlert--warning {
    background-color: lighten($yellow, 55%);
    border-color:     $yellow;

    strong { color: $yellow; }
  }

  .RailsAlert--error {
    background-color: lighten($red, 65%);
    border-color:     $red;

    strong { color: $red; }
  }

  .RailsAlert__close-button {
    align-self: center;
  }
</style>
