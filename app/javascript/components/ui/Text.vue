<template>
    <p class="livespeed-text" :style="style"><slot></slot></p>
</template>

<script>
  import GridCoordinate from 'helpers/grid_coordinate';

  export default {
    computed: {
      transform() {
        let coordinates = new GridCoordinate(this.pos, 1);
        return 'translate(' + coordinates.pxString + ')';
      },

      fontSize() {
        return this.size + 'em';
      },

      style() {
        return {
          transform: this.transform,
          fontFamily: this.font + ', Helvetica, Arial, sans-serif',
          fontSize: this.fontSize,
        }
      }
    },

    props: {
      font: { type: String, default: 'Barbaro' },
      pos: { type: Array, required: true },
      size: { type: Number, default: 2 }
    }
  };
</script>

<style>
    .livespeed-text {
        color: rgba(255, 255, 255, 0.75);
        font-family: 'Cleveland', Helvetica, Arial, sans-serif;
        margin: 0;
        position: absolute;
        text-shadow: 1px 1px 2px black;
        user-select: none;
    }
</style>