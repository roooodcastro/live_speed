<template>
  <div class="game-table-cardslots">
    <div
      v-for="(slot, index) in slots"
      :key="'slot_' + index"
      class="game-table-cardslot"
      :style="style(slot)"
    />
  </div>
</template>

<script>
  import placement      from 'helpers/card_placement';
  import CardCoordinate from 'helpers/card_coordinate';

  export default {
    props: {
      numberOfPlayers: { type: Number, required: true }
    },

    data() {
      return {
        slots: placement.allCardPositions(this.numberOfPlayers)
      };
    },


    methods: {
      slotTransform(slot) {
        const coordinates  = new CardCoordinate(slot.pos);
        const posTransform = 'translate(' + coordinates.toString + ')';
        const rotTransform = 'rotate(' + slot.rot + 'deg)';
        return [posTransform, rotTransform].join(' ');
      },

      style(slot) {
        return {
          transform: this.slotTransform(slot),
          height:    CardCoordinate.scaledCardHeight + 'px',
          width:     CardCoordinate.scaledCardWidth + 'px'
        };
      }
    }
  };
</script>

<style lang="scss">
  .game-table-cardslots {
    position: relative;

    .game-table-cardslot {
      border:        0.2vmin solid rgba(255, 255, 255, 0.7);
      border-radius: 1vmin;
      position:      absolute;
      left:          0;
    }
  }
</style>
