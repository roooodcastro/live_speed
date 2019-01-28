<template>
    <div class="game-table-cardslots">
        <div v-for="(slot, index) in slots"
             :ref="'slot_' + index"
             class="game-table-cardslot"
             :style="slotStyle(slot)">
        </div>
    </div>
</template>

<script>
  import placement      from '../helpers/card_placement';
  import CardCoordinate from '../helpers/card_coordinate';

  export default {
    data() {
      console.log(placement.allCardPositions(this.numberOfPlayers));
      return {
        slots: placement.allCardPositions(this.numberOfPlayers)
      };
    },

    props: {
      numberOfPlayers: { type: Number, required: true }
    },

    methods: {
      slotStyle(slot) {
        let coordinates = new CardCoordinate(slot.pos);
        let left        = coordinates.xPixels * CardCoordinate.cardScale();
        let top         = coordinates.yPixels * CardCoordinate.cardScale();
        return { 'left': left + 'px', 'top': top + 'px' };
      }
    }
  };
</script>