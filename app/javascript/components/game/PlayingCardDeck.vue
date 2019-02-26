<template>
  <div>
    <livespeed-playing-card
      v-for="(card, index) in cards"
      :key="'deckCard_' + index"
      :suit="card.s"
      :rank="card.r"
      :initial-position="[0, 40 - cardYOffset(index)]"
      :initial-order="card.order"
    />
  </div>
</template>

<script>
  import { CARD_VERTICAL_SEPARATION } from 'helpers/constants';
  import placement                    from 'helpers/card_placement';
  import CardCoordinate               from 'helpers/card_coordinate';

  export default {
    props:   {
      cardCount: { type: Number, default: 52 }
    },
    data() {
      return {
        cards:         this.createCards(),
        cardPositions: placement.allCardPositions(2)
      };
    },
    methods: {
      cardYOffset: CardCoordinate.cardYOffset,

      createCards() {
        return [...Array(this.cardCount)].map(() => ({ r: 'a', s: 's' }));
      },

      // Runs the initial card dealing animation.
      // TODO: use roundData to determine how many cards must be dealt for each pile.
      dealCards() {
        const allCardsInfo = this.cardPositions.map((info, index) => {
          info.card = this.$children[index];
          info.pos[1] -= (CARD_VERTICAL_SEPARATION * index);
          return info;
        });

        return allCardsInfo.reduce(placement.dealer, Promise.resolve());
      }
    }
  };
</script>
