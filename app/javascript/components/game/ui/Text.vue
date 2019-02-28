<template>
  <p
    :class="{ 'livespeed-text-invisible': !visible }"
    class="livespeed-text"
    :style="style"
  >
    <slot />
  </p>
</template>

<script>
  import GridCoordinate from 'helpers/grid_coordinate';
  import CardCoordinate from 'helpers/card_coordinate';

  export default {
    props: {
      font:   { type: String, default: 'CardChars' },
      pos:    { type: Array, required: true },
      size:   { type: Number, default: 2 },
      fadeIn: { type: Number, default: 0 }
    },

    data() {
      return {
        visible:   true,
        timeoutId: null
      };
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

    mounted() {
      this.resetFade();
    },

    methods: {
      resetFade() {
        this.visible = true;

        if (this.fadeIn > 0) {
          clearTimeout(this.timeoutId);
          this.timeoutId = setTimeout(function () {
            this.visible = false;
          }.bind(this), this.fadeIn);
        }
      }
    }
  };
</script>

<style>
  .livespeed-text {
    color:       rgba(255, 255, 255, 0.9);
    margin:      0;
    opacity:     1;
    padding:     0 1rem;
    position:    absolute;
    text-align:  center;
    text-shadow: 1px 1px 2px black;
    transition:  all 0.5s;
    user-select: none;
  }

  .livespeed-text-invisible {
    opacity: 0;
  }
</style>
