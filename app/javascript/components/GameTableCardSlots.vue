<template>
    <div class="game-table-cardslots">
        <div v-for="(slot, index) in slots"
             :ref="'slot_' + index"
             class="game-table-cardslot"
             :style="{ top: slot.pos[0], left: slot.pos[1] }">
        </div>
    </div>
</template>

<script>
  import placement from '../helpers/card_placement';

  export default {
    data() {
      return {
        slots: placement.allCardPositions(this.numberOfPlayers)
      };
    },

    props: {
      numberOfPlayers: { type: Number, required: true }
    }
  };
</script>