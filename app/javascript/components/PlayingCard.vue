<template>
    <div :class="cssClass"
         :style="{
         transform: transform,
         zIndex: order,
         filter: dropShadow,
         transition: transition,
         }"></div>
</template>

<script>
  export default {
    name:     'PlayingCard',
    computed: {
      cssClass() {
        if (this.rank !== 'e' && this.suit !== 'e') {
          return 'playing-card card-' + this.suit + '_' + this.rank + (this.flipped ? ' card-f_1' : '');
        } else {
          return '';
        }
      },

      transform() {
        let translate = this.posX + 'vw, ' + this.posY + 'vh';
        return 'scale(' + this.scale + ') translate(' + translate + ') rotate(' + this.rotation + 'deg)';
      },

      transition() {
        return this.isDragging ? 'none' : 'transform 0.2s';
      },

      dropShadow() {
        return 'drop-shadow(0px 0px ' + (2 + this.altitude) + 'px black)';
      },

      posX() {
        let clientW       = document.documentElement.clientWidth;
        let clientH       = document.documentElement.clientHeight;
        let positionX     = this.isDragging ? this.dragPosition[0] : this.position[0];
        let cardWidth     = this.width * this.scale;
        let posVw         = this.pxToVw(this.vwToPx(50) - cardWidth);
        let aspectRatio   = clientW / clientH;
        let correctedMove = positionX * ((100 / aspectRatio) - this.pxToVw(cardWidth)) / 200;
        console.log('cardWidth: ' + cardWidth);
        console.log('posVw: ' + posVw);
        console.log('aspectRatio: ' + aspectRatio);
        console.log('correctedMove: ' + correctedMove);
        return (posVw + correctedMove) / this.scale;
      },

      posY() {
        let positionY     = this.isDragging ? this.dragPosition[1] : this.position[1];
        let cardHeight    = this.height * this.scale;
        let posVh         = this.pxToVh(this.vhToPx(50) - cardHeight);
        let correctedMove = positionY * (100 - this.pxToVh(cardHeight)) / 200;
        return (posVh + correctedMove) / this.scale;
      },

      scale() {
        let clientW = document.documentElement.clientWidth;
        let clientH = document.documentElement.clientHeight;
        if (clientW > clientH) {
          let heightVh     = this.pxToVh(this.height * 1.2);
          let targetHeight = 100 / 5;
          return (targetHeight / heightVh) * (1 + this.altitude / 500);
        } else {
          let widthVw     = this.pxToVw(this.width * 1.2);
          let targetWidth = 100 / 6;
          return (targetWidth / widthVw) * (1 + this.altitude / 500);
        }
      },

      width() {
        return 216;
      },

      height() {
        return 336;
      },

      widthVw() {
        return this.pxToVw(this.width * this.scale);
      },

      heightVh() {
        return this.pxToVh(this.height * this.scale);
      }
    },

    data() {
      return {
        altitude:     0,
        flipped:      this.initialFlipped,
        order:        this.initialOrder,
        position:     this.initialPosition,
        rotation:     this.initialRotation,
        dragPosition: [0, 0],
        isDragging:   false
      };
    },

    props: {
      rank:            {type: String, default: 'a'},
      suit:            {type: String, default: 's'},
      initialPosition: {type: Array, default: () => [0, 0]},
      initialRotation: {type: Number, default: 0},
      initialFlipped:  {type: Boolean, default: true},
      initialOrder:    {type: Number, default: 1}
    },

    methods: {
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
      },

      startDrag() {
        this.isDragging   = true;
        this.dragPosition = this.position;
        this.altitude     = 50;
        this.order += 1000;
      },

      endDrag() {
        this.isDragging = false;
        this.altitude   = 0;
        this.order -= 1000;
      },

      dragMove(ev) {
        if (this.isDragging) {
          let clientW       = document.documentElement.clientWidth;
          let clientH       = document.documentElement.clientHeight;
          let spreadX       = (clientW + (this.width * this.scale)) / clientW;
          let spreadY       = (clientH + (this.height * this.scale)) / clientH;
          let deltaX        = this.pxToVw(ev.movementX * 2 * spreadX);
          let deltaY        = this.pxToVh(ev.movementY * 2 * spreadY);
          this.dragPosition = [this.dragPosition[0] + deltaX, this.dragPosition[1] + deltaY];
        }
      },
    }
  };
</script>
