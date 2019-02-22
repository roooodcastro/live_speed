<template>
  <div class="game-table-gametext">
    {{ text }}
  </div>
</template>

<script>
  import screen from 'helpers/screen';

  export default {

    props: {
      text: { type: String, required: true }
    },
    computed: {
      width() {
        return screen.smallerScreenSize() + 'px';
      },

      style() {
        return {
          width: this.width
        };
      }
    }
  };
</script>

<style>
    .game-table-gametext {
        color:       rgba(255, 255, 255, 0.9);
        font-family: 'Barbaro', serif;
        font-size:   3em;
        left:        calc(50% - 6em);
        position:    absolute;
        text-align:  center;
        text-shadow: 1px 1px 2px black;
        top:         25%;
        width:       12em;
    }
</style>
