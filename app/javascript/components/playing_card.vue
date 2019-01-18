<template>
    <div :class="cssClass" :style="{ transform: transform }"></div>
</template>

<script>
  export default {
    name: 'PlayingCard',
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
      },

      transform() {
        let translate = this.posX + 'vw, ' + this.posY + 'vh';
        return 'scale(' + this.scale + ') translate(' + translate + ') rotate(' + this.rotation + 'deg)';
      },

      posX() {
        let cardWidth = this.width * this.scale;
        let posVw = this.pxToVw(this.vwToPx(50) - cardWidth);
        let correctedMove = this.position[0] * (100 - this.pxToVw(cardWidth)) / 200;
        return (posVw + correctedMove) / this.scale;
      },

      posY() {
        let cardHeight = this.height * this.scale;
        let posVh = this.pxToVh(this.vhToPx(50) - cardHeight);
        let correctedMove = this.position[1] * (100 - this.pxToVh(cardHeight)) / 200;
        return (posVh + correctedMove) / this.scale;
      },

      scale() {
        let heightVh = this.pxToVh(this.height * 1.2);
        let targetHeight = 100 / 5;
        return targetHeight / heightVh;
      },

      width() { return 240; },
      height() { return 336; },
    },

    data() {
      return {
        position: this.initialPosition,
        rotation: this.initialRotation
      }
    },

    props: {
      rank: { type: String, default: 'a' },
      suit: { type: String, default: 's' },
      initialPosition: { type: Array, default: () => [0, 0] },
      initialRotation: { type: Number, default: 0 }
    },

    methods: {
      move(position) {
        this.position = position;
      },
      rotate(angle) {
        this.rotation = angle;
      },
      pxToVw(px) {
        return px * (100 / document.documentElement.clientWidth);
      },

      pxToVh(px) {
        return px * (100 / document.documentElement.clientHeight);
      },

      vwToPx(vw) {
        return vw * (document.documentElement.clientWidth / 100);
      },

      vhToPx(vh) {
        return vh * (document.documentElement.clientHeight / 100);
      },
    }
  }
</script>
