<template>
  <button
    class="livespeed-button"
    :style="style"
    @click="clickCallback"
  >
    <slot />
  </button>
</template>

<script>
  import GridCoordinate from 'helpers/grid_coordinate';
  import CardCoordinate from 'helpers/card_coordinate';

  export default {
    props: {
      font: { type: String, default: 'CardChars' },
      pos:  { type: Array, required: true },
      size: { type: Number, default: 4 }
    },

    computed: {
      transform() {
        const coordinates = new GridCoordinate(this.pos);
        return 'translate(' + coordinates.toString + ')';
      },

      fontSize() {
        return (this.size * CardCoordinate.cardScale()) + 'rem';
      },

      style() {
        return {
          transform:  this.transform,
          fontFamily: this.font + ', Helvetica, Arial, sans-serif',
          fontSize:   this.fontSize
        };
      }
    },

    methods: {
      clickCallback(ev) {
        this.$emit('click', ev, this);
      },

      setDisabled(flag) {
        if (flag) {
          this.$el.setAttribute('disabled', 'disabled');
        } else {
          this.$el.removeAttribute('disabled');
        }
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .livespeed-button {
    background:    transparent;
    border:        0.2vmin solid transparent;
    border-radius: 1vmin;
    color:         rgba($brand-white, 0.8);
    width:         40vmin;
    outline:       none;
    padding:       1vmin 2vmin;
    position:      absolute;
    transition:    0.2s;
    z-index:       500;
  }

  .livespeed-button:hover {
    color: $brand-white;
    cursor: pointer;
  }

  .livespeed-button::before {
    border:        0.2vmin solid rgba($brand-white, 0.8);
    border-radius: 1vmin;
    content:       '';
    height:        100%;
    left:          0;
    position:      absolute;
    top:           0;
    transition:    transform 0.1s, border-color 0.2s;
    width:         100%;
  }

  .livespeed-button:hover::before {
    border-color: $brand-white;
    transform:    scale(1.05);
  }

  .livespeed-button:active, .livespeed-button:focus {
    animation:  livespeed-button-pulse 0.3s;
    box-shadow: 0 0 0 1em rgba(255, 255, 255, 0);
    outline:    none;
  }

  .livespeed-button:active::before, .livespeed-button:focus::before {
    background-color: rgba($brand-white, 0.15);
  }

  @keyframes livespeed-button-pulse {
    0% { box-shadow: 0 0 0 0 rgba($brand-white, 0.5); }
  }
</style>
