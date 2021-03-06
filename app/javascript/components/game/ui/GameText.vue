<template>
  <p
    :class="{ 'GameText--invisible': !visible, 'GameText--animated': animated }"
    class="GameText"
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
      animated:  { type: Boolean, default: false, },
      font:      { type: String, default: 'CardChars', },
      pos:       { type: Array, required: true, },
      size:      { type: Number, default: 2, },
      fadeIn:    { type: Number, default: 0, },
      fullSize:  { type: Boolean, default: false, },
      textAlign: { type: String, default: 'center', },
    },

    data() {
      return {
        visible:   true,
        timeoutId: null,
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
          fontSize:   this.fontSize,
          textAlign:  this.textAlign,
          width:      this.fullSize ? '100%' : 'inherit',
        };
      },
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
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .GameText {
    color:       $brand-white;
    margin:      0;
    opacity:     1;
    padding:     0 1rem;
    position:    absolute;
    text-align:  center;
    text-shadow: 1px 1px 2px $brand-black;
    transition:  all 0.5s;
    user-select: none;

    svg { margin: 0 0.25rem; }
  }

  .GameText--invisible {
    opacity: 0;
  }

  .GameText--animated {
    animation:   GameText--animation 0.5s infinite ease-in-out,
                 GameText--rainbow 5s infinite linear both;
    text-shadow: 0 0 10px $brand-black;
  }

  @keyframes GameText--animation {
    0%, 100% { font-size: 5.75vmin; }
    50% { font-size: 6vmin; }
  }

  @keyframes GameText--rainbow {
    0% { color: violet; }
    7% { color: indigo; }
    14% { color: blue; }
    22% { color: cyan; }
    29% { color: green; }
    36% { color: yellow; }
    43% { color: orange; }
    50% { color: red; }
    57% { color: orange; }
    64% { color: yellow; }
    71% { color: green; }
    79% { color: cyan; }
    87% { color: blue; }
    93% { color: indigo; }
    100% { color: violet; }
  }
</style>
