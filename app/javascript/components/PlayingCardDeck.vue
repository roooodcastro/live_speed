<template>
    <div>
        <livespeed-playing-card v-for="(card, index) in cards"
                                :suit="card.s"
                                :rank="card.r"
                                :initialPosition="[0, 45 - cardYOffset(index)]"
                                :initialOrder="card.order"
                                :key="'deckCard_' + index"/>
    </div>
</template>

<script>
  import { CARD_DEAL_DELAY, CARD_VERTICAL_SEPARATION } from '../helpers/constants';
  import AudioManager                                  from '../helpers/audio_manager';
  import placement                                     from '../helpers/card_placement';
  import CardCoordinate                                from '../helpers/card_coordinate';

  export default {
    data() {
      return {
        cards:         this.createCards(),
        cardPositions: placement.allCardPositions(2)
      };
    },
    props:   {
      cardCount: { type: Number, default: 52 }
    },
    methods: {
      cardYOffset: CardCoordinate.cardYOffset,

      createCards() {
        return [...Array(this.cardCount)].map(() => ({ r: 'a', s: 's' }));
      },

      dealCard(cardIndex, cardInfo) {
        let card = this.$children[cardIndex];
        return new Promise((resolve) => {
          card.move(cardInfo.pos);
          card.rotate(cardInfo.rot);
          card.setOrder(cardInfo.order);
          AudioManager.playDealCard();

          setTimeout(() => resolve(), CARD_DEAL_DELAY);
        });
      },

      // Runs the initial card dealing animation.
      // roundData is used to determine how many cards must be dealt for each pile.
      dealCards(roundData) {
        let dealer = (promise, info, index) => {
          return promise.then(() => {
            if (index > 0) info.pos[1] -= CARD_VERTICAL_SEPARATION;
            info.order = index;
            return this.dealCard(this.cardCount - (index + 1), info);
          });
        };

        let allCardsInfo = this.cardPositions.reduce((acc, info) => acc.concat(Array(info.count).fill(info)), []);
        return allCardsInfo.reduce(dealer, Promise.resolve());
      }
    }
  };
</script>
