<template>
    <div :class="cssClass"
         :style="style"
         @click="onClick"></div>
</template>

<script>
  import CardCoordinate from 'helpers/card_coordinate';

  export default {
    name:     'PlayingCard',
    computed: {
      cssClass() {
        if (this.rank !== 'e' && this.suit !== 'e') {
          const baseClass    = 'playing-card card-' + this.suit + '_' + this.rank;
          const flippedClass = this.flipped ? 'card-f_1' : '';
          const activeClass  = this.isActive ? 'card-active' : '';
          return [baseClass, flippedClass, activeClass].join(' ');
        } else {
          return '';
        }
      },

      style() {
        return {
          transform:  this.transform,
          zIndex:     this.order,
          filter:     this.dropShadow,
          transition: this.transition,
        };
      },

      transform() {
        let scaleTransform = 'scale(' + CardCoordinate.cardScale() + ')';
        let posTransform   = 'translate(' + this.currentPosition.pxString + ')';
        let rotTransform   = 'rotate(' + this.rotation + 'deg)';
        return [scaleTransform, posTransform, rotTransform].join(' ');
      },

      transition() {
        return this.isDragging ? 'none' : 'transform 0.2s';
      },

      dropShadow() {
        if (this.isFeatured) {
          return 'drop-shadow(0px 0px 15px #FFFFAA)';
        } else {
          return 'drop-shadow(0px 0px ' + (2 + this.altitude) + 'px black)';
        }
      },

      currentPosition() {
        return this.isDragging ? this.dragPosition : this.position;
      }
    },

    data() {
      return {
        altitude:     0,
        dragPosition: new CardCoordinate(0, 0),
        flipped:      this.initialFlipped,
        isDragging:   false,
        order:        this.initialOrder,
        position:     new CardCoordinate(this.initialPosition),
        rotation:     this.initialRotation
      };
    },

    props: {
      isActive:        { type: Boolean, default: false },
      isFeatured:      { type: Boolean, default: false },
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

      feature(isFeatured) {
        this.isFeatured = isFeatured;
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
          this.dragPosition = CardCoordinate.fromPixelPosition(ev.clientX, ev.clientY);
        }
      },

      onClick() {
        this.$emit('click');
      }
    }
  };
</script>
