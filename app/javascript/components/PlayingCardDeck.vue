<template>
    <div>
        <livespeed-playing-card v-for="(card, index) in cards"
                                :suit="card.s"
                                :rank="card.r"
                                :initialPosition="[0, -cardYOffset(index)]"
                                :initialOrder="card.order"
                                :key="'deckCard_' + index"/>
    </div>
</template>

<script>
  import { CARD_DEAL_DELAY, CARD_VERTICAL_SEPARATION } from '../constants';
  import { cardYOffset }                               from '../card_deck_helpers';
  import AudioManager                                  from '../audio_manager';

  export default {
    data() {
      return {
        cards:         this.createCards(),
        cardPositions: [
          { pos: [-80, 80], rot: 0, count: 1 },
          { pos: [-48, 80], rot: 0, count: 1 },
          { pos: [-16, 80], rot: 0, count: 1 },
          { pos: [16, 80], rot: 0, count: 1 },
          { pos: [48, 80], rot: 0, count: 1 },
          { pos: [80, 80], rot: 0, count: 15 },
          { pos: [80, -80], rot: 180, count: 1 },
          { pos: [48, -80], rot: 180, count: 1 },
          { pos: [15, -80], rot: 180, count: 1 },
          { pos: [-16, -80], rot: 180, count: 1 },
          { pos: [-48, -80], rot: 180, count: 1 },
          { pos: [-80, -80], rot: 180, count: 15 },
          { pos: [-80, 0], rot: 0, count: 5 },
          { pos: [80, 0], rot: 0, count: 5 },
          { pos: [-20, 0], rot: 0, count: 1 },
          { pos: [20, 0], rot: 0, count: 1 },
        ]
      };
    },
    props:   {
      cardCount: { type: Number, default: 52 }
    },
    methods: {
      cardYOffset: cardYOffset,

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

      dealCards() {
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
