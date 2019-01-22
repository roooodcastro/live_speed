<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in centerPiles[0]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[-10, 0]"
                                :ref="'center_left_' + index"
                                :key="'center_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in centerPiles[1]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[10, 0]"
                                :ref="'center_right_' + index"
                                :key="'center_right_' + index"/>
        <livespeed-playing-card v-for="(card, index) in replacementPiles[0]"
                                :rank="card.r"
                                :suit="card.s"
                                :initial-position="[-40, -cardYOffset(index)]"
                                :ref="'replacement_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in replacementPiles[1]"
                                :rank="card.r"
                                :suit="card.s"
                                :initial-position="[40, -cardYOffset(index)]"
                                :ref="'replacement_right_' + index"/>
    </div>
</template>

<script>
  import Vue           from 'vue';
  import {cardYOffset} from '../card_deck_helpers';

  export default {
    computed: {
      allCards() {
        return this.$children;
      },
    },

    data() {
      return {centerPiles: [], replacementPiles: []};
    },

    methods: {
      cardYOffset: cardYOffset,

      moveCard(card, position, delay) {
        return new Promise((resolve) => {
          card.move(position);

          setTimeout(() => resolve(), delay);
        });
      },

      setCardData(data) {
        this.centerPiles      = data.central_pile.piles;
        this.replacementPiles = data.replacement_piles;
      },

      filterCards(ref) {
        return Object.keys(this.$refs)
          .filter(key => key.includes(ref))
          .map((key) => {
            let ref = this.$refs[key];
            return Array.isArray(ref) ? ref[0] : ref;
          });
      },

      cardOverLeftPile(card) {
        let insideX = Math.abs(card.dragPosition[0] + 10) < card.widthVw * 1.5 && card.dragPosition[0] < 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      },

      cardOverRightPile(card) {
        let insideX = Math.abs(card.dragPosition[0] - 10) < card.widthVw * 1.5 && card.dragPosition[0] > 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      },

      place(cardData, pileIndex) {
        let newPile = this.centerPiles[pileIndex].concat([cardData]);
        this.centerPiles.splice(pileIndex, 1, newPile);

        Vue.nextTick(() => {
          this.dealCards(0).then(this.revealCards);
        });
      }
    }
  };
</script>
