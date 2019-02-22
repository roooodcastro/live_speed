<template>
  <div class="game-table-hand">
    <livespeed-playing-card
      v-for="(card, index) in centerPiles[0]"
      :ref="'center_left_' + index"
      :key="'center_left_' + index"
      :suit="card.s"
      :rank="card.r"
      :initial-position="leftCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="false"
    />
    <livespeed-playing-card
      v-for="(card, index) in centerPiles[1]"
      :ref="'center_right_' + index"
      :key="'center_right_' + index"
      :suit="card.s"
      :rank="card.r"
      :initial-position="rightCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="false"
    />
    <livespeed-playing-card
      v-for="(card, index) in replacementPiles[0]"
      :ref="'replacement_left_' + index"
      :key="'replacement_left_' + index"
      :rank="card.r"
      :suit="card.s"
      :initial-position="[-80, -cardYOffset(index)]"
    />
    <livespeed-playing-card
      v-for="(card, index) in replacementPiles[1]"
      :ref="'replacement_right_' + index"
      :key="'replacement_right_' + index"
      :is-featured="index === 0 && canUseReplacement"
      :is-active="isReplacementCardActive(index)"
      :rank="card.r"
      :suit="card.s"
      :initial-position="[80, -cardYOffset(index)]"
      @click="onReplacementClick"
    />

    <livespeed-arrow
      v-show="canUseReplacement"
      :pos="[72, 20]"
      direction="up"
    />
  </div>
</template>

<script>
  import CardCoordinate from 'helpers/card_coordinate';
  import { CARD_MOVE_DELAY } from 'helpers/constants';

  export default {

    props: {
      centerPiles:       { type: Array, required: true },
      replacementPiles:  { type: Array, required: true },
      canUseReplacement: { type: Boolean, required: true }
    },
    computed: {
      allCards() {
        return this.$children;
      }
    },

    methods: {
      cardYOffset: CardCoordinate.cardYOffset,

      centerPileRot(cardIndex) {
        const randomRotation = ((Math.random() * 5) ** 2) - 10;
        return (cardIndex === 0) ? 0 : randomRotation;
      },

      cardOverPileIndex(card) {
        if (this.isCardOverLeftPile(card)) return 0;
        if (this.isCardOverRightPile(card)) return 1;
        return -1;
      },

      isCardOverLeftPile(card) {
        return card.currentPosition.isOverlapping(new CardCoordinate(-20, 0));
      },

      isCardOverRightPile(card) {
        return card.currentPosition.isOverlapping(new CardCoordinate(20, 0));
      },

      isReplacementCardActive(index) {
        return index === this.replacementPiles[1].length - 1 && this.canUseReplacement;
      },

      place(cardData, pileIndex) {
        const newPile = this.centerPiles[pileIndex].concat([cardData]);
        this.centerPiles.splice(pileIndex, 1, newPile);
      },

      onReplacementClick() {
        this.$emit('replacementClick');
      },

      leftCenterPilePosition(cardIndex) {
        return [-20, -this.cardYOffset(cardIndex)];
      },

      rightCenterPilePosition(cardIndex) {
        return [20, -this.cardYOffset(cardIndex)];
      },

      pullFromReplacements() {
        // TODO: Detect if there are no cards left so we will need to refill it with the center cards.
        return new Promise((resolve) => {
          const repIndex = this.replacementPiles[0].length - 1;
          const leftCard  = this.$refs['replacement_left_' + repIndex][0];
          const rightCard  = this.$refs['replacement_right_' + repIndex][0];
          leftCard.setOrder(100);
          leftCard.move(this.leftCenterPilePosition(this.centerPiles[0].length));
          leftCard.flipUp();
          rightCard.setOrder(100);
          rightCard.move(this.rightCenterPilePosition(this.centerPiles[1].length));
          rightCard.flipUp();
          setTimeout(() => resolve(), CARD_MOVE_DELAY);
        });
      }
    }
  };
</script>