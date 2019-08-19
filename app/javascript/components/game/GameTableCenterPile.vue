<template>
  <div class="game-table-hand">
    <PlayingCard
      v-for="(card, index) in centerPiles[0]"
      :ref="'center_left_' + index"
      :key="'center_left_' + index + timestamp"
      :suit="card.s"
      :rank="card.r"
      :initial-position="leftCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="hideCards"
    />
    <PlayingCard
      v-for="(card, index) in centerPiles[1]"
      :ref="'center_right_' + index"
      :key="'center_right_' + index + timestamp"
      :suit="card.s"
      :rank="card.r"
      :initial-position="rightCenterPilePosition(index)"
      :initial-rotation="centerPileRot(index)"
      :initial-flipped="hideCards"
    />
    <PlayingCard
      v-for="(card, index) in replacementPiles[0]"
      :ref="'replacement_left_' + index"
      :key="'replacement_left_' + index + timestamp"
      :rank="card.r"
      :suit="card.s"
      :initial-position="[-80, -cardYOffset(index)]"
    />
    <PlayingCard
      v-for="(card, index) in replacementPiles[1]"
      :ref="'replacement_right_' + index"
      :key="'replacement_right_' + index + timestamp"
      :is-featured="index === 0 && canUseReplacement"
      :is-active="isReplacementCardActive(index)"
      :rank="card.r"
      :suit="card.s"
      :initial-position="[80, -cardYOffset(index)]"
      @click="onReplacementClick"
    />

    <GameArrow
      v-show="canUseReplacement"
      :pos="[80, 20]"
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
      timestamp:         { type: Number, default: 0, },
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
        const newPile = this.centerPiles[pileIndex].concat([cardData, ]);
        this.centerPiles.splice(pileIndex, 1, newPile);
      },

      onReplacementClick() {
        this.$emit('replacementClick');
      },

      leftCenterPilePosition(cardIndex) {
        return [-20, -this.cardYOffset(cardIndex), ];
      },

      rightCenterPilePosition(cardIndex) {
        return [20, -this.cardYOffset(cardIndex), ];
      },

      leftRepPilePosition(cardIndex) {
        return [-80, -this.cardYOffset(cardIndex), ];
      },

      rightRepPilePosition(cardIndex) {
        return [80, -this.cardYOffset(cardIndex), ];
      },

      pullFromReplacements() {
        return new Promise((resolve) => {
          const repIndex  = this.replacementPiles[0].length - 1;
          const leftCard  = this.$refs['replacement_left_' + repIndex][0];
          const rightCard = this.$refs['replacement_right_' + repIndex][0];
          leftCard.setOrder(100);
          leftCard.move(this.leftCenterPilePosition(this.centerPiles[0].length));
          leftCard.flipUp();
          rightCard.setOrder(100);
          rightCard.move(this.rightCenterPilePosition(this.centerPiles[1].length));
          rightCard.flipUp();
          setTimeout(() => {
            if (this.replacementPiles[0].length > 1) {
              resolve();
            } else {
              this.reshuffleCenterPilesIntoReplacement(leftCard, rightCard)
                .then(() => resolve());
            }
          }, CARD_MOVE_DELAY);
        });
      },

      reshuffleCenterPilesIntoReplacement(leftCard, rightCard) {
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

          // Return the top cards to the correct position (remove the vertical offset)
          leftCard.move(this.leftCenterPilePosition(0));
          rightCard.move(this.rightCenterPilePosition(0));

          // Start the dealer
          cardInfo.reduce(cardPlacement.dealer, Promise.resolve()).then(() => resolve());
        });
      },
    },
  };
</script>
