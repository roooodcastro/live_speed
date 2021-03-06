<template>
  <div class="game-table-hand">
    <PlayingCard
      v-for="(card, index) in centerPiles[0]"
      :ref="'center_left_' + index"
      :key="'center_left_' + index"
      :name="'center_left_' + index"
      :suit="card.s"
      :rank="card.r"
      :order="card.order"
      :initial-position="leftCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="hideCards"
    />
    <PlayingCard
      v-for="(card, index) in centerPiles[1]"
      :ref="'center_right_' + index"
      :key="'center_right_' + index"
      :name="'center_right_' + index"
      :suit="card.s"
      :rank="card.r"
      :order="card.order"
      :initial-position="rightCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="hideCards"
    />
    <PlayingCard
      v-for="(card, index) in replacementPiles[0]"
      :ref="'replacement_left_' + index"
      :key="'replacement_left_' + index"
      :name="'replacement_left_' + index"
      :rank="card.r"
      :suit="card.s"
      :order="card.order"
      :initial-position="[-80, -cardYOffset(index)]"
    />
    <PlayingCard
      v-for="(card, index) in replacementPiles[1]"
      :ref="'replacement_right_' + index"
      :key="'replacement_right_' + index"
      :name="'replacement_right_' + index"
      :is-featured="index === 0 && canUseReplacement"
      :is-active="isReplacementCardActive(index)"
      :rank="card.r"
      :suit="card.s"
      :order="card.order"
      :initial-position="[80, -cardYOffset(index)]"
      @click="onReplacementClick"
    />

    <GameArrow
      v-show="canUseReplacement"
      :pos="[80, 25]"
      direction="up"
    />
  </div>
</template>

<script>
  import PlayingCard from 'components/game/PlayingCard';
  import GameArrow   from 'components/game/ui/GameArrow';

  import CardCoordinate       from 'helpers/card_coordinate';
  import { CARD_MOVE_DELAY, } from 'helpers/constants';
  import cardPlacement        from 'helpers/card_placement';

  export default {
    components: {
      PlayingCard,
      GameArrow,
    },

    props: {
      centerPiles:       { type: Array, required: true, },
      replacementPiles:  { type: Array, required: true, },
      canUseReplacement: { type: Boolean, required: true, },
      gameState:         { type: String, required: true, },
    },

    computed: {
      allCards() {
        return this.$children;
      },

      allCenterCards() {
        return Object.keys(this.$refs)
          .filter(key => key.includes('center_'))
          .map((key) => this.$refs[key][0]);
      },

      hideCards() {
        return ['loading', 'setup', ].includes(this.gameState);
      },
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
        const topCardOrder = this.topCenterCardOrder(pileIndex);
        cardData.order = topCardOrder + 1;
        const newPile = this.centerPiles[pileIndex].concat([cardData, ]);
        this.centerPiles.splice(pileIndex, 1, newPile);
      },

      topCenterCardOrder(pileIndex) {
        const pileName = pileIndex === 0 ? 'left' : 'right';
        const topCard  = Object.keys(this.$refs)
          .filter(key => key.includes('center_' + pileName))
          .map((key) => this.$refs[key][0])
          .slice(-1);
        return topCard.order || 1;
      },

      onReplacementClick() {
        this.$emit('replacementClick');
      },

      centerPilePosition(pileIndex, cardIndex) {

        const xPos = 20 * (pileIndex === 0 ? -1 : 1);
        return [xPos, -this.cardYOffset(cardIndex), ];
      },

      leftCenterPilePosition(cardIndex) {
        return this.centerPilePosition(0, cardIndex);
      },

      rightCenterPilePosition(cardIndex) {
        return this.centerPilePosition(1, cardIndex);
      },

      leftRepPilePosition(cardIndex) {
        return [-80, -this.cardYOffset(cardIndex), ];
      },

      rightRepPilePosition(cardIndex) {
        return [80, -this.cardYOffset(cardIndex), ];
      },

      pullFromReplacements() {
        return new Promise((resolve) => {
          const leftRepIndex  = this.replacementPiles[0].length - 1;
          const rightRepIndex = this.replacementPiles[1].length - 1;
          const leftCard      = this.$refs['replacement_left_' + leftRepIndex][0];
          const rightCard     = this.$refs['replacement_right_' + rightRepIndex][0];
          const leftOrder     = this.topCenterCardOrder(0) + 1;
          const rightOrder    = this.topCenterCardOrder(1) + 1;
          if (this.replacementPiles[0].length > 1 && this.replacementPiles[1].length > 1) {
            leftCard.move(this.leftCenterPilePosition(this.centerPiles[0].length));
            leftCard.setOrder(leftOrder);
            leftCard.flipUp();
            rightCard.move(this.rightCenterPilePosition(this.centerPiles[1].length));
            rightCard.setOrder(rightOrder);
            rightCard.flipUp();
          }
          setTimeout(() => {
            if (this.replacementPiles[0].length > 1 && this.replacementPiles[1].length > 1) {
              resolve();
            } else {
              this.reshuffleCenterPilesIntoReplacement()
                .then(() => {
                  // Return the top cards to the correct position (remove the vertical offset)
                  leftCard.move(this.leftCenterPilePosition(0));
                  leftCard.setOrder(0);
                  leftCard.flipUp();
                  rightCard.move(this.rightCenterPilePosition(0));
                  rightCard.setOrder(0);
                  rightCard.flipUp();
                  resolve();
                });
            }
          }, CARD_MOVE_DELAY);
        });
      },

      reshuffleCenterPilesIntoReplacement() {
        return new Promise(resolve => {
          // Define properties for the card dealer
          const cardInfo = this.allCenterCards.map((card, index) => {
            const posFunction = (index % 2 === 0) ? this.leftRepPilePosition : this.rightRepPilePosition;
            return {
              card:     card,
              pos:      posFunction(Math.floor(index / 2)),
              delay:    CARD_MOVE_DELAY / 5,
              flipDown: true,
            };
          });

          // Start the dealer
          cardInfo.reduce(cardPlacement.dealer, Promise.resolve()).then(() => resolve());
        });
      },

      flipCards() {
        this.allCenterCards.forEach((card) => card.flipUp());
      },
    },
  };
</script>
