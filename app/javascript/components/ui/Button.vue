<template>
    <button class="livespeed-button" @click="clickCallback" :style="{ transform: transform }">
        <slot></slot>
    </button>
</template>

<script>
  import GridCoordinate from '../../helpers/grid_coordinate';

  export default {
    computed: {
      transform() {
        let coordinates = new GridCoordinate(this.pos, 1);
        return 'translate(' + coordinates.pxString + ')';
      }
    },

    props: {
      click: { type: Function, required: true },
      pos:   { type: Array, required: true }
    },

    methods: {
      clickCallback(ev) {
        this.click(ev, this);
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

<style>
    .livespeed-button {
        background:       transparent;
        border:           3px solid transparent;
        border-radius:    .5em;
        color:            rgba(255, 255, 255, 0.6);
        font-size:        1.5em;
        font-family:      'Cleveland', Helvetica, Arial, sans-serif;
        line-height:      2em;
        min-width:        10em;
        outline:          none;
        padding:          0 1em;
        position:         relative;
        transform-origin: center;
        transition:       0.2s;
    }

    .livespeed-button:hover { color: rgba(255, 255, 255, 0.9); }

    .livespeed-button::before {
        border:        3px solid rgba(255, 255, 255, 0.75);
        border-radius: .5em;
        content:       '';
        height:        100%;
        left:          0;
        position:      absolute;
        top:           0;
        transition:    transform 0.1s, border-color 0.2s;
        width:         100%;
    }

    .livespeed-button:hover::before {
        border-color: rgba(255, 255, 255, 0.9);
        transform:    scale(1.05);
    }

    .livespeed-button:active, .livespeed-button:focus {
        animation:  livespeed-button-pulse 0.3s;
        box-shadow: 0 0 0 1em rgba(255, 255, 255, 0);
        outline:    none;
    }

    .livespeed-button:active::before, .livespeed-button:focus::before { background-color: rgba(255, 255, 255, 0.15); }

    @keyframes livespeed-button-pulse {
        0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.5); }
    }
</style>