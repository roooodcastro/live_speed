<template>
    <div>
        <div :class="cssClass"></div>
    </div>
</template>

<script>
  export default {
    computed: {
      color() {
        if (this.suit === 'd' || this.suit === 'h') {
          return '#A00';
        } else {
          return '#111';
        }
      },

      cssClass() {
        return 'playing-card card-' + this.suit + '_' + this.rank;
      }
    },

    props: {
      rank: { type: String, default: 'a' },
      suit: { type: String, default: 's' }
    }
  }
</script>
