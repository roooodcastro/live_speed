<template>
    <p class="livespeed-text" :style="{ transform: transform, fontSize: fontSize }"><slot></slot></p>
</template>

<script>
  import GridCoordinate from '../helpers/grid_coordinate';

  export default {
    computed: {
      transform() {
        let coordinates = new GridCoordinate(this.pos, 1);
        return 'translate(' + coordinates.pxString + ')';
      },

      fontSize() {
        return this.size + 'em';
      }
    },

    props: {
      pos: { type: Array, required: true },
      size: { type: Number, default: 2 }
    }
  };
</script>

<style>
    .livespeed-text {
        color: rgba(255, 255, 255, 0.75);
        font-family: 'Cleveland', Helvetica, Arial, sans-serif;
        position: absolute;
    }
</style>