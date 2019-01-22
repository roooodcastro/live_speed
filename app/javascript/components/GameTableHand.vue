<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in draw"
                                :rank="card.r"
                                :suit="card.s"
                                :initial-position="drawCardPos(index)"
                                :initial-rotation="cardRotation"
                                :ref="'draw_' + playerIndex + '_' + index"
                                :key="'draw_' + playerIndex + '_' + index"/>
        <livespeed-playing-card v-for="(card, index) in hand"
                                :rank="card.r"
                                :suit="card.s"
                                :initial-position="handCardPos(index)"
                                :initial-rotation="cardRotation"
                                :initial-flipped="false"
                                :ref="'card_' + playerIndex + '_' + index"
                                :key="'card_' + playerIndex + '_' + index"/>
    </div>
</template>

<script>
  import Vue                        from 'vue';
  import {CARD_VERTICAL_SEPARATION} from "../constants";

  export default {
    computed: {
      cardRotation() {
        return this.playerIndex * 180;
      },

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
      setHandData(handData) {
        this.hand = handData.cards;
        this.draw = handData.draw_pile;
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
            // card.$el.parentNode.removeChild(card.$el);
            Vue.nextTick(() => {
              let card = this.filterCards('card')[cardIndex];
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
      },

      handCardPos(cardIndex) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posX = ((cardIndex * 15) - 40) * mult;
        let posY = 80 * mult;
        return [posX, posY];
      },

      drawCardPos(cardIndex) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posX = 40 * mult;
        let posY = (80 * mult) - (cardIndex * CARD_VERTICAL_SEPARATION);
        return [posX, posY];
      }
    }
  };
</script>
