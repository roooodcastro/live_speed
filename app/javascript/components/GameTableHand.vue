<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="index in 15" :ref="'draw_' + playerIndex + '_' + index"/>
        <livespeed-playing-card v-for="index in 5" :ref="'card_' + playerIndex + '_' + index"/>
    </div>
</template>

<script>
  import AudioManager from '../audio_manager';

  export default {
    computed: {
      handCards() {
        return Object.keys(this.$refs)
          .filter(key => key.includes('card'))
          .map((key) => {
            return this.$refs[key][0];
          });
      },

      drawCards() {
        return Object.keys(this.$refs)
          .filter(key => key.includes('draw'))
          .map((key) => {
            return this.$refs[key][0];
          });
      }
    },

    data() {
      return {};
    },

    mounted() {
    },

    props:    {
      playerIndex: {type: Number, required: true}
    },

    methods:  {
      moveCard(card, position, rotation, delay) {
        return new Promise((resolve) => {
          card.move(position);
          card.rotate(rotation);

          setTimeout(() => resolve(), delay);
        });
      },

      dealHandCard(cardIndex, delay) {
        let mult     = (this.playerIndex === 0) ? 1 : -1;
        let posY     = 80 * mult;
        let posIndex = cardIndex - 2;
        let posX     = ((15 * posIndex) - 10) * mult;
        let card     = this.handCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], this.playerIndex * 180, delay);
      },

      dealDrawCard(cardIndex, delay) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posY = (80 * mult) - (cardIndex * 0.2);
        let posX = 40 * mult;
        let card = this.drawCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], this.playerIndex * 180, delay);
      },

      dealCards() {
        return new Promise((resolve) => {
          let delay      = 150;
          let handDealer = (promise, index) => promise.then(() => this.dealHandCard(index, delay));
          let drawDealer = (promise, index) => promise.then(() => this.dealDrawCard(index, delay));
          let promise    = Array.from(Array(this.handCards.length).keys()).reduce(handDealer, Promise.resolve());
          Array.from(Array(this.drawCards.length).keys()).reduce(drawDealer, promise).then(() => resolve());
        });
      },

      setHandData(handData) {
        this.handCards.forEach((card, index) => card.setRankSuit(handData.cards[index]));
        this.drawCards.forEach((card, index) => card.setRankSuit(handData.draw_pile[index]));
      },
      revealCards() {
        return new Promise((resolve) => {
          this.handCards.forEach((card) => card.flipUp());
          setTimeout(() => resolve(), 500);
        });
      },

      expandArray(length) {
        return Array.from(Array(length).keys());
      }
    }
  };
</script>
