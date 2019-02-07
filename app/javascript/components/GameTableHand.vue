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
                                :is-active="playerIndex === 0"
                                :rank="card.r"
                                :suit="card.s"
                                :initial-position="handCardPos(index)"
                                :initial-rotation="cardRotation"
                                :initial-flipped="false"
                                :ref="'card_' + playerIndex + '_' + index"
                                :key="'card_' + playerIndex + '_' + index"/>
        <livespeed-text :pos="playerNamePos"
                        :size="1.5"
                        font="Barbaro">
            {{ player.name }}
        </livespeed-text>
    </div>
</template>

<script>
  import Vue                                           from 'vue';
  import { CARD_MOVE_DELAY, CARD_VERTICAL_SEPARATION } from 'helpers/constants';

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
      },

      playerNamePos() {
        const mult = (this.playerIndex === 0) ? 1 : -1;
        return [75 * mult, 60 * mult];
      }
    },

    data() {
      return {
        draw: this.initialDraw,
        hand: this.initialHand
      };
    },

    props: {
      playerIndex: { type: Number, required: true },
      initialHand: { type: Array, required: true },
      initialDraw: { type: Array, required: true },
      player:      { type: Object, required: true }
    },

    methods: {
      indexOfCard(card) {
        return this.handCards.indexOf(card);
      },

      dataOfCard(card) {
        return this.hand[this.indexOfCard(card)];
      },

      removeCard(card) {
        return new Promise((resolve) => {
          const cardIndex = this.handCards.indexOf(card);
          const removed   = this.hand[cardIndex];
          this.hand.splice(cardIndex, 1, { r: 'e', s: 'e' });
          Vue.nextTick(() => resolve(removed));
        });
      },

      pullFromDraw(cardIndex) {
        return new Promise((resolve) => {
          const drawIndex = this.draw.length - 1;
          const card      = this.$refs['draw_' + this.playerIndex + '_' + drawIndex][0];
          card.setOrder(100);
          card.move(this.handCardPos(cardIndex));
          card.flipUp();
          setTimeout(() => {
            const newCard = this.draw.splice(this.draw.length - 1, 1);
            if (newCard.length > 0) {
              this.hand.splice(cardIndex, 1, newCard[0]);
            }
            resolve();
          }, CARD_MOVE_DELAY);
        });
      },

      handCardPos(cardIndex) {
        const mult = (this.playerIndex === 0) ? 1 : -1;
        const posX = ((cardIndex * 32) - 80) * mult;
        const posY = 95 * mult;
        return [posX, posY];
      },

      drawCardPos(cardIndex) {
        const mult = (this.playerIndex === 0) ? 1 : -1;
        const posX = 80 * mult;
        const posY = (95 * mult) - (cardIndex * CARD_VERTICAL_SEPARATION);
        return [posX, posY];
      }
    }
  };
</script>
