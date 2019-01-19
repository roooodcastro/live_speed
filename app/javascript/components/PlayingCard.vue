<template>
    <div :class="cssClass" :style="{ transform: transform, zIndex: order, filter: dropShadow }"></div>
</template>

<script>
  export default {
    name:     'PlayingCard',
    computed: {
      cssClass() {
        return 'playing-card card-' + this.suit + '_' + this.rank + (this.flipped ? ' card-f_1' : '');
      },

      transform() {
        let translate = this.posX + 'vw, ' + this.posY + 'vh';
        return 'scale(' + this.scale + ') translate(' + translate + ') rotate(' + this.rotation + 'deg)';
      },

      dropShadow() {
        return 'drop-shadow(0px 0px ' + (2 + this.altitude) + 'px black)';
      },

      posX() {
        let cardWidth     = this.width * this.scale;
        let posVw         = this.pxToVw(this.vwToPx(50) - cardWidth);
        let correctedMove = this.position[0] * (100 - this.pxToVw(cardWidth)) / 200;
        return (posVw + correctedMove) / this.scale;
      },

      posY() {
        let cardHeight    = this.height * this.scale;
        let posVh         = this.pxToVh(this.vhToPx(50) - cardHeight);
        let correctedMove = this.position[1] * (100 - this.pxToVh(cardHeight)) / 200;
        return (posVh + correctedMove) / this.scale;
      },

      scale() {
        let heightVh     = this.pxToVh(this.height * 1.2);
        let targetHeight = 100 / 5;
        return targetHeight / heightVh;
      },

      width() {
        return 216;
      },
      height() {
        return 336;
      }
    },

    data() {
      return {
        altitude: 0,
        flipped:  this.initialFlipped,
        order:    1,
        position: this.initialPosition,
        rotation: this.initialRotation,
        rank:     this.initialRank,
        suit:     this.initialSuit
      };
    },

    props: {
      initialRank:     {type: String, default: 'a'},
      initialSuit:     {type: String, default: 's'},
      initialPosition: {type: Array, default: () => [0, 0]},
      initialRotation: {type: Number, default: 0},
      initialFlipped:  {type: Boolean, default: true}
    },

    methods: {
      setRankSuit(data) {
        this.rank = data.r;
        this.suit = data.s;
      },
      flipUp() {
        this.flipped = false;
      },
      flipDown() {
        this.flipped = true;
      },
      move(position) {
        this.position = position;
      },
      rotate(angle) {
        this.rotation = angle;
      },
      setOrder(newOrder) {
        this.order = newOrder;
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
      }
    }
  };
</script>
