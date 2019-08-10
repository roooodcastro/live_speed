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
  import { CARD_VERTICAL_SEPARATION, } from 'helpers/constants';
  import placement                    from 'helpers/card_placement';
  import CardCoordinate               from 'helpers/card_coordinate';

  export default {
    props: {
      roundData: { type: Object, required: true, },
    },

    computed: {
      cards() {
        return [...Array(this.cardCount), ].map(() => ({ r: 'a', s: 's', }));
      },

      numPlayers() {
        if (!this.roundData.hands) return 0;

        return this.roundData.hands.length;
      },

      cardCount() {
        const numberOfDecks = Math.ceil(this.numPlayers / 2);
        return numberOfDecks * 52;
      },
    },

    methods: {
      cardYOffset: CardCoordinate.cardYOffset,

      // Runs the initial card dealing animation.
      dealCards() {
        const hand1 = this.roundData.hands[0];
        const hand2 = this.roundData.hands[1];

        // TODO: Find a better way to do this
        const counts = [
          hand1.cards[0].s ? 1 : 0,
          hand1.cards[1].s ? 1 : 0,
          hand1.cards[2].s ? 1 : 0,
          hand1.cards[3].s ? 1 : 0,
          hand1.cards[4].s ? 1 : 0,
          hand1.draw_pile.length,
          hand2.cards[0].s ? 1 : 0,
          hand2.cards[1].s ? 1 : 0,
          hand2.cards[2].s ? 1 : 0,
          hand2.cards[3].s ? 1 : 0,
          hand2.cards[4].s ? 1 : 0,
          hand2.draw_pile.length,
          this.roundData.replacement_piles[0].length,
          this.roundData.replacement_piles[1].length,
          this.roundData.central_pile.piles[0].length,
          this.roundData.central_pile.piles[1].length,
        ];

        // Access the correct index to get the card components (the counts above mess up the indexes)
        let cardIndex = this.cards.length - 1;

        const allCardsInfo = placement.allCardPositions(this.numPlayers).reduce((acc, info, index) => {
          const stack = Array(counts[index]).fill(info);

          return acc.concat(stack.map((cardInfo, stackIndex) => {
            return {
              card:  this.$children[cardIndex--],
              pos:   [cardInfo.pos[0], cardInfo.pos[1] - (CARD_VERTICAL_SEPARATION * stackIndex), ],
              rot:   cardInfo.rot,
              order: 100 + stackIndex,
            };
          }));
        }, []);

        return allCardsInfo.reduce(placement.dealer, Promise.resolve());
      },
    },
  };
</script>
