<template>
  <div
    id="game_table"
    class="game-table-container"
  >
    <div v-show="state === 'loading'">
      <livespeed-loading-suits />
    </div>

    <div v-show="!playedDealAnimation">
      <playing-card-deck ref="cardDeck" />
    </div>

    <div
      v-show="playedDealAnimation"
      class="game-table-gamearea"
      @mousedown="onDragStart"
      @mouseup="onDragEnd"
      @mousemove="onDragMove"
    >
      <GameTableHand
        v-for="(hand, index) in hands"
        :ref="'hand_' + hand.player.id"
        :key="'hand_' + hand.player.id"
        :player-index="index"
        :player="hand.player"
        :initial-hand="hand.cards"
        :initial-draw="hand.draw_pile"
      />

      <GameTableCenterPile
        ref="centerPile"
        :center-piles="centerPiles"
        :replacement-piles="replacementPiles"
        :can-use-replacement="canUseReplacement"
        @replacementClick="onReplacementClick"
      />

      <GameTableText :text="playerMessage" />
    </div>

    <div v-show="state === 'setup' && playedDealAnimation">
      <pre-game-overlay
        ref="preGameOverlay"
        @playerReady="onReadyClick"
      />
    </div>

    <GameTableCardSlots
      v-show="state !== 'loading'"
      :number-of-players="2"
    />
  </div>
</template>

<script>
  import apiClient           from 'api/match_channel';
  import Round               from 'games/speed/round';
  import Message             from 'games/speed/message';
  import GameTableHand       from 'components/game/GameTableHand';
  import GameTableCenterPile from 'components/game/GameTableCenterPile';
  import PlayingCardDeck     from 'components/game/PlayingCardDeck';
  import GameTableText       from 'components/game/GameTableText';
  import GameTableCardSlots  from 'components/game/GameTableCardSlots';
  import PreGameOverlay      from 'components/game/PreGameOverlay';

  export default {
    components: {
      GameTableHand,
      GameTableCenterPile,
      GameTableText,
      GameTableCardSlots,
      PlayingCardDeck,
      PreGameOverlay
    },

    props: {
      roundId:  { type: String, required: true },
      playerId: { type: String, required: true }
    },

    data() {
      return {
        api:                 null,
        dragHold:            false,
        isDragging:          null,
        controller:          new Round(this.playerId, this.onControllerStateChange),
        playedDealAnimation: false,

        roundData: {}
      };
    },

    computed: {
      hands() {
        return this.roundData.hands;
      },

      state() {
        return Round.state(this.roundData, this.playerId);
      },

      centerPileComponent() {
        return this.$refs['centerPile'];
      },

      playerMessage() {
        return Message.generate(this.roundData, this.state, this.playerId);
      },

      centerPiles() {
        if (!this.roundData.central_pile) return [];
        return this.roundData.central_pile.piles;
      },

      replacementPiles() {
        return this.roundData.replacement_piles || [];
      },

      canUseReplacement() {
        return this.roundData.can_use_replacement || false;
      }
    },

    mounted() {
      this.api = apiClient.subscribeToApi(this);
    },

    methods: {
      onApiReceiveRoundData(data) {
        if (data.player_id !== this.playerId) return;

        this.updateData(data);

        this.$refs['cardDeck'].dealCards(this.controller.data)
          .then(function () {
            this.playedDealAnimation = true;
          }.bind(this));
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
            .then(() => this.centerPileComponent.place(response.card_data, response.pile_index))
            .then(() => playerHandComponent.pullFromDraw(cardIndex))
            .then(() => this.updateData(response));

          if (response.round.winner_id) {
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
        if (this.isDragging) {
          this.isDragging.endDrag();
          this.isDragging = null;
          this.dragHold   = false;
        }
      },

      onPlayerReady(data) {
        this.updateData(data);
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
        this.centerPileComponent.pullFromReplacements()
          .then(() => this.updateData(data));
      },

      onDragStart(ev) {
        const card         = ev.target.__vue__;
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
          const pileIndex = this.centerPileComponent.cardOverPileIndex(card);

          if (pileIndex >= 0) return this.playCard(card, pileIndex);

          this.isDragging.endDrag();
          this.isDragging = null;
        }
      },

      playCard(card, pileIndex) {
        const cardIndex = this.playerHandComponent(this.playerId).indexOfCard(card);
        this.api.playCard(cardIndex, pileIndex, this.playerId);
      },

      playerHandComponent(playerId) {
        return this.$refs['hand_' + playerId][0];
      },

      updateData(data) {
        this.roundData = Round.parseRoundData(data.round, this.playerId);
        this.controller.updateData(data.round);
      }
    }
  };
</script>

<style lang="scss">
  .game-table-container {
    background-image:  asset-url('felt.png');
    background-repeat: repeat;
    box-sizing:        border-box;
    display:           block;
    height:            100%;
    position:          relative;

    &:before {
      content:    '';
      background: radial-gradient(circle, rgba(0, 0, 0, 0) 0%, rgba(0, 0, 0, 0.5) 100%);
      position:   absolute;
      bottom:     0;
      left:       0;
      right:      0;
      top:        0;
    }
  }

  .game-table-gamearea {
    display:  block;
    position: absolute;
    bottom:   0;
    left:     0;
    right:    0;
    top:      0;
  }

  .game-table-hand { position: relative; }

  .game-table-cardslots {
    position: relative;

    .game-table-cardslot {
      border:        6px solid rgba(255, 255, 255, 0.7);
      border-radius: 24px;
      height:        324px;
      position:      absolute;
      width:         216px;
      top:           6px;
      left:          0;
    }
  }
</style>