<template>
    <div class="game-table-cardslots">
        <div v-for="(slot, index) in slots"
             :key="'slot_' + index"
             class="game-table-cardslot"
             :style="{ transform: slotTransform(slot) }">
        </div>
    </div>
</template>

<script>
  import placement      from 'helpers/card_placement';
  import CardCoordinate from 'helpers/card_coordinate';

  export default {
    data() {
      return {
        slots: placement.allCardPositions(this.numberOfPlayers)
      };
    },

    props: {
      numberOfPlayers: { type: Number, required: true }
    },

    methods: {
      slotTransform(slot) {
        const coordinates = new CardCoordinate(slot.pos);
        const scaleTransform = 'scale(' + CardCoordinate.cardScale() + ')';
        const posTransform   = 'translate(' + coordinates.pxString + ')';
        const rotTransform   = 'rotate(' + slot.rot + 'deg)';
        return [scaleTransform, posTransform, rotTransform].join(' ');
      },
    }
  };
</script>
