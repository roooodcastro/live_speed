<template>
    <div>
        <div :class="cssClass"></div>
    </div>
</template>

<script>
  export default {
    computed: {
      unicode() {
        let suit_code = {c: 'D', d: 'C', h: 'B', s: 'A'}[this.suit] || 'A';
        let rank_code = {a: '1', 10: 'A', j: 'B', q: 'D', k: 'E'}[this.rank] || this.rank || '0';
        return '&#x1F0' + suit_code + rank_code + ';';
      },

      color() {
        if (this.suit === 'd' || this.suit === 'h') {
          return '#A00';
        } else {
          return '#111';
        }
      },

      cssClass() {
        return 'playing-card svg-' + this.suit + '_' + this.rank;
      }
    },

    props: {
      rank: { type: String, default: 'a' },
      suit: { type: String, default: 's' }
    }
  }
</script>
