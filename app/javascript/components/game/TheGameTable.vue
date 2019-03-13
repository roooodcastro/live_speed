<template>
  <div class="game-table-container">
    <div
      id="game_table"
      class="game-table"
    >
      <div v-show="state === 'loading'">
        <livespeed-loading-suits />
      </div>

      <div v-show="!playedDealAnimation">
        <playing-card-deck
          ref="cardDeck"
          :round-data="roundData"
        />
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
          :game-state="state"
        />

        <GameTableCenterPile
          ref="centerPile"
          :center-piles="centerPiles"
          :replacement-piles="replacementPiles"
          :can-use-replacement="canUseReplacement"
          :game-state="state"
          @replacementClick="onReplacementClick"
        />

        <livespeed-text
          ref="playerMessage"
          :pos="[0, -35]"
          :size="6"
          :animated="state === 'win'"
          font="Barbaro"
        >
          {{ playerMessage }}
        </livespeed-text>

        <livespeed-text
          ref="submessage"
          :pos="[0, 35]"
          :size="6"
          :fade-in="playerSubMessageTimer"
          font="Barbaro"
        >
          {{ playerSubMessage }}
        </livespeed-text>
      </div>

      <div v-show="(state === 'win' || state === 'lose') && playedDealAnimation">
        <livespeed-button
          :pos="[47.5, 35]"
          @click="onNextRoundClick"
        >
          {{ t('game.menu.next_round') }}
        </livespeed-button>

        <livespeed-button
          :pos="[-47.5, 35]"
          @click="onQuitGameClick"
        >
          {{ t('game.menu.quit') }}
        </livespeed-button>
      </div>

      <livespeed-button
        v-show="showReadyButton"
        :pos="[0, 35]"
        @click="onReadyClick"
      >
        {{ t('game.ready') }}
      </livespeed-button>

      <GameTableCardSlots
        v-show="state !== 'loading'"
        :number-of-players="2"
      />

      <GameMenu />
    </div>
  </div>
</template>

<script>
  import apiClient           from 'api/match_channel';
  import Round               from 'games/speed/round';
  import Message             from 'games/speed/message';
  import GameTableHand       from 'components/game/GameTableHand';
  import GameTableCenterPile from 'components/game/GameTableCenterPile';
  import PlayingCardDeck     from 'components/game/PlayingCardDeck';
  import GameTableCardSlots  from 'components/game/GameTableCardSlots';
  import GameMenu            from 'components/game/ui/GameMenu';
  import I18n                from 'vendor/i18n-js-game.js.erb';

  export default {
    components: {
      GameMenu,
      GameTableHand,
      GameTableCenterPile,
      GameTableCardSlots,
      PlayingCardDeck
    },

    props: {
      roundId:  { type: String, required: true },
      playerId: { type: String, required: true }
    },

    data() {
      return {
        api:                   null,
        dragHold:              false,
        isDragging:            null,
        controller:            new Round(this.playerId, this.onControllerStateChange),
        playedDealAnimation:   false,
        playerSubMessage:      '',
        playerSubMessageTimer: 2000,

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
        return !!this.roundData.can_use_replacement && !this.controller.playerReadyToReplace;
      },

      showReadyButton() {
        return this.state === 'setup' && this.playedDealAnimation && !this.controller.playerReadyToPlay;
      }
    },

    mounted() {
      this.api = apiClient.subscribeToApi(this);
      window.addEventListener('resize', this.onWindowResize);
    },

    beforeDestroy: function () {
      window.removeEventListener('resize', this.onWindowResize);
    },

    methods: {
      onRoundData(data) {
        if (data.player_id !== this.playerId) return;

        this.updateData(data);

        this.$nextTick(() => {
          this.$refs['cardDeck'].dealCards(this.controller.data)
            .then(function () {
              this.playedDealAnimation = true;
            }.bind(this));
        });
      },

      onReadyClick() {
        this.api.markReady(this.playerId);
      },

      onPlayerReady(data) {
        this.updateData(data);
      },

      onPlayerConnected(data) {
        this.updateData(data);

        if (this.playerId !== data.player_id) {
          const playerName = this.controller.playerHand(data.player_id).player.name;
          this.setPlayerSubmessage(Message.playerConnected(playerName), 5000);
        }
      },

      onPlayerDisconnected(data) {
        this.updateData(data);

        if (this.playerId !== data.player_id) {
          const playerName = this.controller.playerHand(data.player_id).player.name;
          this.setPlayerSubmessage(Message.playerDisconnected(playerName), 5000);
        }
      },

      onReplacementClick() {
        if (['game', 'staled_game'].includes(this.state)) {
          if (this.canUseReplacement) {
            this.api.playReplacementPile(this.playerId);
          } else {
            this.setPlayerSubmessage(Message.invalidReplacement(), 2000);
          }
        }
      },

      onReplacementResponse(data) {
        if (!data.round.can_use_replacement) {
          this.centerPileComponent.pullFromReplacements()
            .then(() => this.updateData(data));
        } else {
          this.updateData(data);
        }
      },

      onPlayResponse(response) {
        if (response.success) {
          const cardIndex           = response.card_index;
          const playerHandComponent = this.playerHandComponent(response.player_id);
          const card                = playerHandComponent.handCards[cardIndex];
          playerHandComponent.removeCard(card)
            .then(() => this.centerPileComponent.place(response.card_data, response.pile_index))
            .then(() => playerHandComponent.pullFromDraw(cardIndex))
            .then(() => this.updateData(response));
        } else {
          this.setPlayerSubmessage(Message.invalidPlay(), 2000);
        }
        if (this.isDragging) {
          this.isDragging.endDrag();
          this.isDragging = null;
          this.dragHold   = false;
        }
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
        if (this.isDragging) {
          this.dragHold   = true;
          const card      = this.isDragging;
          const pileIndex = this.centerPileComponent.cardOverPileIndex(card);

          if (pileIndex >= 0) return this.playCard(card, pileIndex);

          this.isDragging.endDrag();
          this.isDragging = null;
        }
        this.dragHold = false;
      },

      onWindowResize() {
        // TODO: Find a way to make the game resize dynamically;
      },

      onNextRoundClick() {
        window.location = '/matches/' + this.controller.matchId + '/play';
      },

      onQuitGameClick() {
        window.location = '/matches';
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
      },

      setPlayerSubmessage(message, timer) {
        if (timer) this.playerSubMessageTimer = timer;
        this.playerSubMessage = message;
        this.$refs.submessage.resetFade();
      },

      t(name) {
        return I18n.t(name);
      }
    }
  };
</script>

<style lang="scss">
  .game-table-container {
    align-items:       center;
    background-image:  url('../../images/felt.png');
    background-repeat: repeat;
    bottom:            0;
    box-sizing:        border-box;
    display:           flex;
    justify-content:   center;
    left:              0;
    position:          absolute;
    right:             0;
    top:               0;

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

  .game-table {
    /*background: rgba(0, 255, 0, 0.1); // To debug game area boundaries*/
    height:   100vmin;
    position: relative;
    width:    100vmin;
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
</style>
