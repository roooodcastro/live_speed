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
  import CardCoordinate from '../helpers/card_coordinate';
  import screen         from '../helpers/screen';

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
        let translate = this.isDragging ? this.dragPosition.pxString : this.position.pxString;
        return 'scale(' + this.scale + ') translate(' + translate + ') rotate(' + this.rotation + 'deg)';
      },

      transition() {
        return this.isDragging ? 'none' : 'transform 0.2s';
      },

      dropShadow() {
        return 'drop-shadow(0px 0px ' + (2 + this.altitude) + 'px black)';
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
      },

      scale() {
        return this.position.cardScale;
      }
    },

    data() {
      return {
        altitude:     0,
        flipped:      this.initialFlipped,
        order:        this.initialOrder,
        position:     new CardCoordinate(this.initialPosition),
        rotation:     this.initialRotation,
        dragPosition: new CardCoordinate(0, 0),
        isDragging:   false
      };
    },

    props: {
      rank:            { type: String, default: 'a' },
      suit:            { type: String, default: 's' },
      initialPosition: { type: Array, default: () => [0, 0] },
      initialRotation: { type: Number, default: 0 },
      initialFlipped:  { type: Boolean, default: true },
      initialOrder:    { type: Number, default: 1 }
    },

    methods: {
      flipUp() {
        this.flipped = false;
      },

      flipDown() {
        this.flipped = true;
      },

      move(position) {
        this.position = new CardCoordinate(position);
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
          // let clientW       = screen.clientWidth();
          // let clientH       = screen.clientHeight();
          // let spreadX       = (clientW + (this.width * this.scale)) / clientW;
          // let spreadY       = (clientH + (this.height * this.scale)) / clientH;
          // let deltaX        = this.pxToVw(ev.movementX * 2 * spreadX);
          // let deltaY        = this.pxToVh(ev.movementY * 2 * spreadY);
          // this.dragPosition = new CardCoordinate(this.dragPosition[0] + deltaX, this.dragPosition[1] + deltaY);

          this.dragPosition = CardCoordinate.fromPixelPosition(ev.clientX, ev.clientY);
        }
      }
    }
  };
</script>
