<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in centerPiles[0]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[-10, -cardYOffset(index)]"
                                :initial-rotation="centerPileRot(index)"
                                :initial-flipped="false"
                                :ref="'center_left_' + index"
                                :key="'center_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in centerPiles[1]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[10, -cardYOffset(index)]"
                                :initial-rotation="centerPileRot(index)"
                                :initial-flipped="false"
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

      centerPileRot(cardIndex) {
        let randomRotation = ((Math.random() * 5) ** 2) - 10;
        return (cardIndex === 0) ? 0 : randomRotation;
      },

      setCardData(data) {
        this.centerPiles      = data.central_pile.piles;
        this.replacementPiles = data.replacement_piles;
      },

      isCardOverLeftPile(card) {
        let insideX = Math.abs(card.dragPosition[0] + 10) < card.widthVw * 1.5 && card.dragPosition[0] < 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      },

      isCardOverRightPile(card) {
        let insideX = Math.abs(card.dragPosition[0] - 10) < card.widthVw * 1.5 && card.dragPosition[0] > 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      },

      place(cardData, pileIndex) {
        let newPile = this.centerPiles[pileIndex].concat([cardData]);
        this.centerPiles.splice(pileIndex, 1, newPile);
      }
    }
  };
</script>
