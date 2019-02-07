<template>
    <div id="game_table" class="game-table-container">
        <div v-show="state === 'loading'">
            <livespeed-loading-suits/>
        </div>

        <div v-show="!playedDealAnimation">
            <playing-card-deck ref="cardDeck"/>
        </div>

        <div v-show="playedDealAnimation"
             class="game-table-gamearea"
             @mousedown="onDragStart"
             @mouseup="onDragEnd"
             @mousemove="onDragMove">

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

        <div v-show="state === 'setup' && playedDealAnimation">
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
        api:                 undefined,
        dragHold:            false,
        isDragging:          undefined,
        controller:          undefined,
        playedDealAnimation: false
      };
    },

    methods: {
      onApiReceiveRoundData(data) {
        if (data.player_id !== this.playerId) return;

        this.controller.loadData(data.round);
        this.centerPile.setCardData(data.round);

        this.$refs['cardDeck'].dealCards(controller.data)
          .then(() => {
            this.playedDealAnimation = true;
            if (this.controller.allPlayersReady) this.controller.state = 'game';
          });
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
            .then(() => playerHandComponent.pullFromDraw(cardIndex))
            .then(() => this.controller.update(response.round));

          if (response.round.winner_id) {
            // TODO: Someone has won! Check if it was the player or the opponent and show the appropriate interface
            const winnerId = response.round.winner_id;
            if (winnerId === this.playerId) {
              console.log('You won!');
            } else {
              console.log('You lost!');
            }
          }
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
          case 'loading:setup':
            break;
          case 'setup:game':
            break;
        }
      },

      onReplacementResponse(data) {
        // TODO: Make replacement animation, make replacement work
      },

      onDragStart(ev) {
        const card = ev.target.__vue__;
        const isPlayerCard = this.playerHandComponent(this.playerId).handCards.includes(card);
        if (isPlayerCard && this.state === 'game' && !this.dragHold) {
          if (this.isDragging) this.isDragging.endDrag();
          this.isDragging = card;
          card.startDrag();
        }
      },

      onDragMove(ev) {
        if (this.isDragging && !this.dragHold) {
          this.isDragging.dragMove(ev);
        }
      },

      onDragEnd() {
        this.dragHold = false;
        if (this.isDragging) {
          this.dragHold   = true;
          const card      = this.isDragging;
          const pileIndex = this.centerPile.cardOverPileIndex(card);

          if (pileIndex >= 0) return this.playCard(card, pileIndex);

          this.isDragging.endDrag();
          this.isDragging = undefined;
        }
      },

      playCard(card, pileIndex) {
        const cardIndex = this.playerHandComponent(this.playerId).indexOfCard(card);
        this.api.playCard(cardIndex, pileIndex, this.playerId);
      },

      playerHandComponent(playerId) {
        return this.$refs['hand_' + playerId][0];
      }
    }
  };
</script>