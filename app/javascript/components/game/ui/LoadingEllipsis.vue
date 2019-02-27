<template>
  <span class="livespeed-loading-ellipsis">
    {{ text }}
  </span>
</template>

<script>
  export default {
    data() {
      return { dotCount: 0, intervalId: -1 };
    },

    computed: {
      text() {
        return '.'.repeat(Math.min(this.dotCount, 3));
      }
    },

    mounted() {
      this.intervalId = setInterval(function () {
        this.dotCount = (this.dotCount + 1) % 5;
      }.bind(this), 200);
    },

    beforeDestroy() {
      clearInterval(this.intervalId);
    }
  };
</script>

<style>
  .livespeed-loading-ellipsis {
    display: inline-block;
    text-align: left;
    width:   2em;
  }
</style>
