<template>
    <div id="game_table" class="game-table-container">
        <div v-show="state === 'loading'">
            <livespeed-loading-suits/>
        </div>

        <div v-show="state === 'setup'">
            <playing-card-deck ref="cardDeck"/>
        </div>

        <div v-show="state === 'game' || state === 'ready'"
             class="game-table-gamearea"
             @mousedown="dragStart"
             @mouseup="dragEnd"
             @mousemove="dragMove">

            <GameTableHand v-for="(hand, index) in hands"
                           :ref="'hand_' + hand.player.id"
                           :key="'hand_' + hand.player.id"
                           :player-index="index"
                           :player="hand.player"
                           :initial-hand="hand.cards"
                           :initial-draw="hand.draw_pile"/>

            <GameTableCenterPile ref="centerPile" @replacementClick="onReplacementClick"/>

            <GameTableText :text="playerMessage"></GameTableText>
        </div>

        <div v-show="state === 'ready'">
            <pre-game-overlay @playerReady="onReadyClick" ref="preGameOverlay"/>
        </div>

        <GameTableCardSlots v-show="state !== 'loading'" :number-of-players="2"></GameTableCardSlots>
    </div>
</template>

<script>
  import apiClient           from 'api/match_channel';
  import Round               from 'games/speed/round';
  import Message             from 'games/speed/message';
  import GameTableHand       from 'components/GameTableHand';
  import GameTableCenterPile from 'components/GameTableCenterPile';
  import PlayingCardDeck     from 'components/PlayingCardDeck';
  import GameTableText       from 'components/GameTableText';
  import GameTableCardSlots  from 'components/GameTableCardSlots';
  import PreGameOverlay      from 'components/PreGameOverlay';

  export default {
    components: {
      GameTableHand,
      GameTableCenterPile,
      GameTableText,
      GameTableCardSlots,
      PlayingCardDeck,
      PreGameOverlay
    },

    computed: {
      hands() {
        return controller.hands;
      },

      centerPile() {
        return this.$refs['centerPile'];
      },

      state() {
        if (!this.controller) return 'loading';
        return this.controller.state;
      },

      playerMessage() {
        return Message.generate(this.round.data, this.playerId);
      }
    },

    mounted() {
      this.api        = apiClient.subscribeToApi(this);
      this.controller = new Round(this.playerId, this.api, this.onControllerStateChange);
    },

    props: {
      roundId:  { type: String, required: true },
      playerId: { type: String, required: true }
    },

    data() {
      return {
        api:        undefined,
        dragHold:   false,
        isDragging: undefined,
        controller: undefined
      };
    },

    methods: {
      onApiReceiveRoundData(data) {
        if (data.player_id !== this.playerId) return;

        this.controller.loadData(data.round);
        this.centerPile.setCardData(data.round);

        this.$refs['cardDeck'].dealCards(controller.data)
          .then(() => this.controller.state = 'ready');
      },

      onReadyClick() {
        this.api.markReady(this.playerId);
      },

      onReplacementClick() {
        this.api.playReplacementPile(this.playerId);
      },

      onCardPlay(response) {
        if (response.success) {
          const cardIndex           = response.card_index;
          const playerHandComponent = this.playerHandComponent(response.player_id);
          const card                = playerHandComponent.handCards[cardIndex];
          playerHandComponent.removeCard(card)
            .then(() => this.centerPile.place(response.card_data, response.pile_index))
            .then(() => playerHandComponent.pullFromDraw(cardIndex));
        } else {
          console.log('Invalid play!');
        }
        this.isDragging.endDrag();
        this.isDragging = undefined;
        this.dragHold   = false;
      },

      onPlayerReady(data) {
        this.controller.setPlayerAsReady(data.player_id);
        this.$refs['preGameOverlay'].setOpponentsAsReady(this.controller.allOpponentsReady);
      },

      // TODO: Use Vuex to manage state
      onControllerStateChange(oldState, newState) {
        console.log('game changed from ' + oldState + ' to ' + newState);

        switch ([oldState, newState].join(':')) {
          case 'setup:ready':
            if (this.controller.allPlayersReady) this.controller.state = 'game';
            break;
          case 'ready:game':
            break;
        }
      },

      onReplacementResponse(data) {
      },

      isPlayerCard(card) {
        return this.playerHandComponent(this.playerId).handCards.includes(card);
      },

      dragStart(ev) {
        const card = ev.target.__vue__;
        if (this.isPlayerCard(card) && this.state === 'game' && !this.dragHold) {
          if (this.isDragging) this.isDragging.endDrag();
          this.isDragging = card;
          card.startDrag();
        }
      },

      dragEnd() {
        this.dragHold = false;
        if (this.isDragging) {
          const card    = this.isDragging;
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
        const cardIndex = this.playerHandComponent(this.playerId).indexOfCard(card);
        this.submitPlay(cardIndex, pileIndex);
      },

      submitPlay(cardIndex, pileIndex) {
        this.api.playCard(cardIndex, pileIndex, this.playerId);
      },

      playerHandComponent(playerId) {
        return this.$refs['hand_' + playerId][0];
      }
    }
  };
</script>