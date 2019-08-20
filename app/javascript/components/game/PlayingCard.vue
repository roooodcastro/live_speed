<template>
  <div
    :class="cssClass"
    :style="style"
    :data-transform="transform"
    @click="onClick"
  />
</template>

<script>
  import CardCoordinate              from 'helpers/card_coordinate';
  import { CARD_WIDTH, CARD_HEIGHT, } from 'helpers/constants';

  export default {
    name: 'PlayingCard',

    props: {
      isActive:        { type: Boolean, default: false, },
      isFeatured:      { type: Boolean, default: false, },
      rank:            { type: String, default: 'a', },
      suit:            { type: String, default: 's', },
      initialPosition: { type: Array, default: () => [0, 0, ], },
      initialRotation: { type: Number, default: 0, },
      initialFlipped:  { type: Boolean, default: true, },
      initialOrder:    { type: Number, default: 1, },
    },

    data() {
      return {
        altitude:     0,
        dragPosition: new CardCoordinate(0, 0),
        flipped:      this.initialFlipped,
        isDragging:   false,
        order:        this.initialOrder,
        position:     new CardCoordinate(this.initialPosition),
        rotation:     this.initialRotation,
      };
    },
    computed: {
      cssClass() {
        if (this.rank !== 'e' && this.suit !== 'e') {
          const baseClass    = 'playing-card card-' + this.suit + '_' + this.rank;
          const flippedClass = this.flipped ? 'card-f_1' : '';
          const activeClass  = this.isActive ? 'card-active' : '';
          return [baseClass, flippedClass, activeClass, ].join(' ');
        } else {
          return '';
        }
      },

      style() {
        return {
          transform:  this.transform,
          zIndex:     this.order,
          filter:     this.dropShadow,
          position:   'absolute',
          transition: this.transition,
          width:      this.cssSize[0] + 'px',
          height:     this.cssSize[1] + 'px',
        };
      },

      cssSize() {
        return [CARD_WIDTH * CardCoordinate.cardScale(), CARD_HEIGHT * CardCoordinate.cardScale(), ];
      },

      transform() {
        const posTransform = 'translate(' + this.currentPosition.toString + ')';
        const rotTransform = 'rotate(' + this.rotation + 'deg)';
        return [posTransform, rotTransform, ].join(' ');
      },

      transition() {
        return this.isDragging ? 'none' : 'transform 0.3s';
      },

      dropShadow() {
        if (this.isFeatured) {
          return 'drop-shadow(0px 0px 15px #FFFFAA)';
        } else {
          return 'drop-shadow(0px 0px ' + (2 + this.altitude) + 'px rgba(0, 0, 0, 0.5))';
        }
      },

      currentPosition() {
        return this.isDragging ? this.dragPosition : this.position;
      },
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
          const touch = ev.touches[0];
          this.dragPosition = CardCoordinate.fromPixelPosition(touch.clientX, touch.clientY);
          this.$forceUpdate();
        }
      },

      onClick() {
        this.$emit('click');
      },
    },
  };
</script>

<style lang="scss">
  .playing-card {
    background-image:           url("../../images/playing_cards.svg");
    background-repeat:          no-repeat;
    background-size:            1000% 600%;
    position:                   absolute;
    transition-timing-function: ease-in-out;

    &:after {
      content:         "";
      background:      url("../../images/playing_cards.svg") 11.11111111111111% 0 no-repeat;
      background-size: 1000% 600%;
      opacity:         0;
      transition:      opacity 0.5s;
      position:        absolute;
      top:             0;
      right:           0;
      bottom:          0;
      left:            0;
    }
  }

  .playing-card.card-active:hover {
    filter: drop-shadow(0px 0px 10px #FFFFAA) !important;
  }

  .playing-card.card-f_1.card-active:hover { filter: none !important; }

  // Flipped cards
  .card-f_1::after { opacity: 1; }

  .card-f_2 { background-position: 22.22222222222222% 0; }

  // Joker cards
  .card-j_1 { background-position: 77.77777777777777% 0; }

  .card-j_2 { background-position: 22.22222222222222% 20%; }

  // Other cards
  .card-c_2 { background-position: 33.333333333333336% 0; }

  .card-d_2 { background-position: 0 20%; }

  .card-h_2 { background-position: 11.11111111111111% 20%; }

  .card-s_2 { background-position: 33.333333333333336% 20%; }

  .card-c_3 { background-position: 44.44444444444444% 0; }

  .card-d_3 { background-position: 44.44444444444444% 20%; }

  .card-h_3 { background-position: 0 40%; }

  .card-s_3 { background-position: 11.11111111111111% 40%; }

  .card-c_4 { background-position: 22.22222222222222% 40%; }

  .card-d_4 { background-position: 33.333333333333336% 40%; }

  .card-h_4 { background-position: 44.44444444444444% 40%; }

  .card-s_4 { background-position: 55.55555555555556% 0; }

  .card-c_5 { background-position: 55.55555555555556% 20%; }

  .card-d_5 { background-position: 55.55555555555556% 40%; }

  .card-h_5 { background-position: 66.66666666666667% 0; }

  .card-s_5 { background-position: 66.66666666666667% 20%; }

  .card-c_6 { background-position: 66.66666666666667% 40%; }

  .card-d_6 { background-position: 0 60%; }

  .card-h_6 { background-position: 11.11111111111111% 60%; }

  .card-s_6 { background-position: 22.22222222222222% 60%; }

  .card-c_7 { background-position: 33.333333333333336% 60%; }

  .card-d_7 { background-position: 44.44444444444444% 60%; }

  .card-h_7 { background-position: 55.55555555555556% 60%; }

  .card-s_7 { background-position: 66.66666666666667% 60%; }

  .card-c_8 { background-position: 0 0; }

  .card-d_8 { background-position: 77.77777777777777% 20%; }

  .card-h_8 { background-position: 77.77777777777777% 40%; }

  .card-s_8 { background-position: 77.77777777777777% 60%; }

  .card-c_9 { background-position: 0 80%; }

  .card-d_9 { background-position: 11.11111111111111% 80%; }

  .card-h_9 { background-position: 22.22222222222222% 80%; }

  .card-s_9 { background-position: 33.333333333333336% 80%; }

  .card-c_a { background-position: 44.44444444444444% 80%; }

  .card-d_a { background-position: 55.55555555555556% 80%; }

  .card-h_a { background-position: 66.66666666666667% 80%; }

  .card-s_a { background-position: 77.77777777777777% 80%; }

  .card-c_j { background-position: 88.88888888888889% 0; }

  .card-d_j { background-position: 88.88888888888889% 20%; }

  .card-h_j { background-position: 88.88888888888889% 40%; }

  .card-s_j { background-position: 88.88888888888889% 60%; }

  .card-c_k { background-position: 88.88888888888889% 80%; }

  .card-d_k { background-position: 100% 0; }

  .card-h_k { background-position: 100% 20%; }

  .card-s_k { background-position: 100% 40%; }

  .card-c_q { background-position: 100% 60%; }

  .card-d_q { background-position: 100% 80%; }

  .card-h_q { background-position: 0 100%; }

  .card-s_q { background-position: 11.11111111111111% 100%; }

  .card-c_10 { background-position: 22.22222222222222% 100%; }

  .card-d_10 { background-position: 33.333333333333336% 100%; }

  .card-h_10 { background-position: 44.44444444444444% 100%; }

  .card-s_10 { background-position: 55.55555555555556% 100%; }
</style>
