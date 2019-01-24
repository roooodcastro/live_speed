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
  import Vue                                         from 'vue';
  import {CARD_DEAL_DELAY, CARD_VERTICAL_SEPARATION} from "../constants";

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

      indexOfCard(card) {
        return this.handCards.indexOf(card);
      },

      dataOfCard(card) {
        return this.hand[this.indexOfCard(card)];
      },

      removeCard(card) {
        return new Promise((resolve) => {
          let cardIndex = this.handCards.indexOf(card);
          let removed   = this.hand[cardIndex];
          this.hand.splice(cardIndex, 1, {r: 'e', s: 'e'});
          Vue.nextTick(() => resolve(removed));
        });
      },

      pullFromDraw(cardIndex) {
        return new Promise((resolve) => {
          let drawIndex = this.draw.length - 1;
          let card = this.$refs['draw_' + this.playerIndex + '_' + drawIndex][0];
          card.setOrder(100);
          card.move(this.handCardPos(cardIndex));
          card.flipUp();
          setTimeout(() => {
            let newCard = this.draw.splice(this.draw.length - 1, 1);
            if (newCard.length > 0) {
              this.hand.splice(cardIndex, 1, newCard[0]);
            }
            resolve();
          }, CARD_DEAL_DELAY);
        });
      },

      handCardPos(cardIndex) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posX = ((cardIndex * 32) - 80) * mult;
        let posY = 80 * mult;
        return [posX, posY];
      },

      drawCardPos(cardIndex) {
        let mult = (this.playerIndex === 0) ? 1 : -1;
        let posX = 80 * mult;
        let posY = (80 * mult) - (cardIndex * CARD_VERTICAL_SEPARATION);
        return [posX, posY];
      }
    }
  };
</script>
