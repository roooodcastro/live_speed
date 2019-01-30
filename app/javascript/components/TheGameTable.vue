<template>
    <div id="game_table" class="game-table-container">
        <div v-show="status === 'loading'">
            <livespeed-loading-suits/>
        </div>

        <div v-show="status === 'setup'">
            <playing-card-deck ref="cardDeck"/>
        </div>

        <div v-show="status === 'game' || status === 'ready'"
             class="game-table-gamearea"
             @mousedown="dragStart"
             @mouseup="dragEnd"
             @mousemove="dragMove">

            <GameTableHand v-for="(hand, index) in hands"
                           :ref="'hand_' + hand.player_id"
                           :key="'hand_' + hand.player_id"
                           :player-index="index"
                           :initial-hand="hand.cards"
                           :initial-draw="hand.draw_pile"/>

            <GameTableCenterPile ref="centerPile"/>

            <GameTableText :text="playerMessage"></GameTableText>
        </div>

        <div v-show="status === 'ready'">
            <livespeed-overlay>
                <livespeed-text :pos="[0, 22.5]" :size="3">Click READY to start playing:</livespeed-text>
                <livespeed-button :click="readyButtonClick" :pos="[0, 47.5]">Ready!</livespeed-button>
            </livespeed-overlay>
        </div>

        <GameTableCardSlots v-show="status !== 'loading'" :number-of-players="2"></GameTableCardSlots>
    </div>
</template>

<script>
  import apiClient           from '../channels/match_channel';
  import GameTableHand       from './GameTableHand';
  import GameTableCenterPile from './GameTableCenterPile';
  import PlayingCardDeck     from './PlayingCardDeck';
  import GameTableText       from './GameTableText';
  import GameTableCardSlots  from './GameTableCardSlots';

  export default {
    components: { GameTableHand, GameTableCenterPile, GameTableText, GameTableCardSlots, PlayingCardDeck },
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
        dragHold:      false,
        hands:         [],
        isDragging:    undefined,
        roundData:     {},
        status:        'loading',
        timeoutId:     0,
        api:           undefined,
        playerMessage: ''
      };
    },

    methods: {
      fetchRoundData() {
        this.api.fetchData();
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
        this.status    = 'setup';
        this.centerPile.setCardData(round);

        this.$refs['cardDeck'].dealCards(round)
          .then(() => this.status = 'ready');
      },

      isPlayerCard(card) {
        return this.handComponent(this.playerId).handCards.includes(card);
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
        let cardIndex = this.handComponent(this.playerId).indexOfCard(card);
        this.submitPlay(cardIndex, pileIndex);
      },

      submitPlay(cardIndex, pileIndex) {
        this.api.playCard(cardIndex, pileIndex, this.playerId);
      },

      processPlayResponse(response) {
        console.log(response);

        if (response.success) {
          let cardIndex     = response.card_index;
          let handComponent = this.handComponent(response.player_id);
          let card          = handComponent.handCards[cardIndex];
          handComponent.removeCard(card)
            .then(() => this.centerPile.place(response.card_data, response.pile_index))
            .then(() => handComponent.pullFromDraw(cardIndex));
        } else {
          console.log('Invalid play!');
        }
        this.isDragging.endDrag();
        this.isDragging = undefined;
        this.dragHold   = false;
      },

      handComponent(playerId) {
        return this.$refs['hand_' + playerId][0];
      },

      readyButtonClick(ev) {
        this.status = 'game';
      }
    },
    props:   {
      roundId:  { type: String, required: true },
      playerId: { type: String, required: true }
    }
  };
</script>