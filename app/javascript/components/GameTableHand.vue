<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in draw"
                                :rank="card.r"
                                :suit="card.s"
                                :ref="'draw_' + playerIndex + '_' + index"
                                :key="'draw_' + playerIndex + '_' + index"/>
        <livespeed-playing-card v-for="(card, index) in hand"
                                :rank="card.r"
                                :suit="card.s"
                                :ref="'card_' + playerIndex + '_' + index"
                                :key="'card_' + playerIndex + '_' + index"/>
    </div>
</template>

<script>
  import Vue          from 'vue';
  import AudioManager from '../audio_manager';

  const DEFAULT_DELAY = 10;

  export default {
    computed: {
      allCards() {
        return this.handCards.concat(this.drawCards);
      },
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
      return {hand: [], draw: []};
    },

    props: {
      playerIndex: {type: Number, required: true}
    },

    methods: {
      moveCard(card, position, rotation) {
        return new Promise((resolve) => {
          card.move(position);
          card.rotate(rotation);

          setTimeout(() => resolve(), DEFAULT_DELAY);
        });
      },

      dealHandCard(cardIndex) {
        let mult     = (this.playerIndex === 0) ? 1 : -1;
        let posY     = 80 * mult;
        let posIndex = cardIndex - 2;
        let posX     = ((15 * posIndex) - 10) * mult;
        let card     = this.handCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], this.playerIndex * 180, DEFAULT_DELAY);
      },

      dealDrawCard(cardIndex) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posY = (80 * mult) - (cardIndex * 0.2);
        let posX = 40 * mult;
        let card = this.drawCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], this.playerIndex * 180, DEFAULT_DELAY);
      },

      dealCards() {
        return new Promise((resolve) => {
          let handDealer = (promise, index) => promise.then(() => this.dealHandCard(index));
          let drawDealer = (promise, index) => promise.then(() => this.dealDrawCard(index));
          let promise    = Array.from(Array(this.handCards.length).keys()).reduce(handDealer, Promise.resolve());
          Array.from(Array(this.drawCards.length).keys()).reduce(drawDealer, promise).then(() => resolve());
        });
      },

      setHandData(handData) {
        this.hand = handData.cards;
        this.draw = handData.draw_pile;
      },

      revealCards() {
        return new Promise((resolve) => {
          this.handCards.forEach((card) => card.flipUp());
          setTimeout(() => resolve(), 500);
        });
      },

      removeCard(card) {
        let cardIndex       = this.handCards.indexOf(card);
        let removed         = this.hand[cardIndex];
        let removedPosition = card.position;
        let newFromDraw     = this.draw.pop();
        let drawedCard      = this.filterCards('draw')[0];
        console.log('hand cards: ' + this.printCards(this.hand));
        console.log('removed index ' + cardIndex + ': ' + this.printCard(removed));
        this.hand.splice(cardIndex, 1, {r: 'e', s: 'e'});
        console.log('hand cards: ' + this.printCards(this.hand));

        if (newFromDraw) {
          this.moveCard(drawedCard, removedPosition, 0, DEFAULT_DELAY).then(() => {
            console.log('replaced ' + this.hand[cardIndex].r + ' with ' + newFromDraw.r);
            this.hand.splice(cardIndex, 1, newFromDraw);
            console.log('hand cards: ' + this.printCards(this.hand));
            card.$el.parentNode.removeChild(card.$el);
            Vue.nextTick(() => {
              let card = this.filterCards('card')[cardIndex];
              debugger;
              console.log(card);
              card.flipUp();
            });
          });
        }

        return removed;
      },

      filterCards(ref) {
        return Object.keys(this.$refs)
          .filter(key => key.includes(ref))
          .map((key) => {
            let ref = this.$refs[key];
            return Array.isArray(ref) ? ref[0] : ref;
          });
      },

      printCard(cardData) {
        return cardData.r + ' of ' + cardData.s;
      },

      printCards(cards) {
        return cards.reduce((string, card) => {
          return string + ', ' + this.printCard(card);
        }, '');
      }
    }
  };
</script>
