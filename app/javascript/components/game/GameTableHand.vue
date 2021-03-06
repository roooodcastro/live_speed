<template>
  <div class="game-table-hand">
    <PlayingCard
      v-for="(card, index) in draw"
      :ref="'draw_' + playerIndex + '_' + index"
      :key="'draw_' + playerIndex + '_' + index"
      :name="'draw_' + playerIndex + '_' + index"
      :rank="card.r"
      :suit="card.s"
      :initial-position="drawCardPos(index)"
      :initial-rotation="cardRotation"
    />
    <PlayingCard
      v-for="(card, index) in hand"
      v-show="!!card.s"
      :ref="'card_' + playerIndex + '_' + index"
      :key="'card_' + playerIndex + '_' + index"
      :name="'card_' + playerIndex + '_' + index"
      :is-active="playerIndex === 0"
      :rank="card.r"
      :suit="card.s"
      :initial-position="handCardPos(index)"
      :initial-rotation="cardRotation"
      :initial-flipped="hideCards"
    />
    <GameText
      :pos="playerNamePos"
      :size="3.5"
      :full-size="true"
      :text-align="playerNameAlign"
      font="Barbaro"
    >
      <template v-if="playerIndex === 0">
        <FontAwesomeIcon
          v-for="index in roundWins"

          :key="index"
          icon="trophy"
        />
      </template>

      {{ player.name }}

      <template v-if="playerIndex !== 0">
        <FontAwesomeIcon
          v-for="index in roundWins"
          :key="index"
          icon="trophy"
        />
      </template>
    </GameText>
  </div>
</template>

<script>
  import PlayingCard from 'components/game/PlayingCard';
  import GameText    from 'components/game/ui/GameText';

  import Vue                                            from 'vue';
  import { FontAwesomeIcon, }                           from '@fortawesome/vue-fontawesome';
  import { CARD_MOVE_DELAY, CARD_VERTICAL_SEPARATION, } from 'helpers/constants';

  export default {
    components: {
      PlayingCard,
      GameText,
      FontAwesomeIcon,
    },

    props: {
      playerIndex: { type: Number, required: true, },
      initialHand: { type: Array, required: true, },
      initialDraw: { type: Array, required: true, },
      player:      { type: Object, required: true, },
      gameState:   { type: String, required: true, },
      matchInfo:   { type: Object, default: null, },
    },

    data() {
      return {
        draw: this.initialDraw,
        hand: this.initialHand,
      };
    },
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
        return [0, 49.5 * mult, ];
      },

      playerNameAlign() {
        return this.playerIndex === 0 ? 'right' : 'left';
      },

      hideCards() {
        return ['loading', 'setup', ].includes(this.gameState);
      },

      roundWins() {
        if (this.matchInfo) {
          return this.matchInfo.wins[this.player.id];
        } else {
          return 0;
        }
      },
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
          this.hand.splice(cardIndex, 1, { r: 'e', s: 'e', });
          Vue.nextTick(() => resolve(removed));
        });
      },

      pullFromDraw(cardIndex) {
        return new Promise((resolve) => {
          const drawIndex = this.draw.length - 1;
          const drawCards = this.$refs['draw_' + this.playerIndex + '_' + drawIndex];
          if (!drawCards) return resolve();

          const card = drawCards[0];
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
        const posY = 75 * mult;
        return [posX, posY, ];
      },

      drawCardPos(cardIndex) {
        const mult = (this.playerIndex === 0) ? 1 : -1;
        const posX = 80 * mult;
        const posY = (75 * mult) - (cardIndex * CARD_VERTICAL_SEPARATION);
        return [posX, posY, ];
      },

      flipCards() {
        this.handCards.forEach((card) => card.flipUp());
      },
    },
  };
</script>
