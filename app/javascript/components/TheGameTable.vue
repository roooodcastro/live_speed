<template>
    <div id="game_table" class="game-table-container">
        <div v-show="status === 'game'"
             class="game-table-gamearea"
             @mousedown="dragStart"
             @mouseup="dragEnd"
             @mousemove="dragMove">

            <GameTableHand v-for="(hand, index) in hands"
                           :ref="'hand' + index"
                           :key="'hand' + index"
                           :player-index="index"
                           :initial-hand="hand.cards"
                           :initial-draw="hand.draw_pile"/>

            <GameTableCenterPile ref="centerPile"/>
        </div>
        <playing-card-deck v-show="status === 'setup'" ref="cardDeck"/>
    </div>
</template>

<script>
  import apiClient           from '../match_channel';
  import GameTableHand       from './GameTableHand';
  import GameTableCenterPile from './GameTableCenterPile';
  import PlayingCardDeck     from './PlayingCardDeck';

  export default {
    components: { GameTableHand, GameTableCenterPile, PlayingCardDeck },
    computed:   {
      centerPile() {
        return this.$refs['centerPile'];
      }
    },

    mounted() {
      this.api = apiClient.subscribeToApi(this);
    },

    data() {
      return {
        dragHold:   false,
        hands:      [],
        isDragging: undefined,
        roundData:  {},
        status:     'setup',
        timeoutId:  0,
        api:        undefined
      };
    },

    methods: {
      fetchRoundData() {
        this.api.fetchData(this.roundId);
      },

      parseRoundData(round) {
        let sortedHands = round.hands.sort((h1, h2) => {
          if (h1.player_id === this.playerId) {
            return -1;
          } else if (h2.player_id === this.playerId) {
            return 1;
          } else {
            return 0;
          }
        });

        this.roundData = round;
        this.hands     = sortedHands;
        this.centerPile.setCardData(round);

        this.$refs['cardDeck'].dealCards()
          .then(() => this.status = 'game');
      },

      isPlayerCard(card) {
        return this.handComponent(0).handCards.includes(card);
      },

      dragStart(ev) {
        let card = ev.target.__vue__;
        if (this.isPlayerCard(card) && this.status === 'game' && !this.dragHold) {
          if (this.isDragging) this.isDragging.endDrag();
          this.isDragging = card;
          card.startDrag();
        }
      },

      dragEnd() {
        this.dragHold = false;
        if (this.isDragging) {
          let card      = this.isDragging;
          this.dragHold = true;
          if (this.centerPile.isCardOverLeftPile(card)) {
            this.playCard(card, 0);
          } else if (this.centerPile.isCardOverRightPile(card)) {
            this.playCard(card, 1);
          } else {
            this.isDragging.endDrag();
            this.isDragging = undefined;
          }
        }
      },

      dragMove(ev) {
        if (this.isDragging && !this.dragHold) {
          this.isDragging.dragMove(ev);
        }
      },

      playCard(card, pileIndex) {
        let cardData = this.handComponent(0).dataOfCard(card);

        this.submitPlay(cardData, pileIndex)
          .then(
            (cardData) => { // Card was successfully played
              let cardIndex = this.handComponent(0).indexOfCard(card);
              this.handComponent(0).removeCard(card)
                .then(() => this.centerPile.place(cardData, pileIndex))
                .then(() => this.handComponent(0).pullFromDraw(cardIndex));
            },
            (error) => { // Play was invalid, card must be returned to the hand
              // TODO: handle error
            })
          .finally(() => {
            this.isDragging.endDrag();
            this.isDragging = undefined;
            this.dragHold   = false;
          });
      },

      submitPlay(cardData, pileIndex) {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            // TODO: Submit to Rails and abort play if move is invalid
            if (true) {
              resolve(cardData);
            } else {
              reject('Invalid Play');
            }
          }, 200);
        });
      },

      handComponent(playerIndex) {
        return this.$refs['hand' + playerIndex][0];
      }
    },
    props:   {
      roundId:  { type: String, required: true },
      playerId: { type: String, required: true }
    }
  };
</script>