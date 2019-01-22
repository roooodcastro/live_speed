<template>
    <div id="game_table" class="game-table-container">
        <div v-show="status === 'game'"
             @mousedown="dragStart"
             @mouseup="dragEnd"
             @mousemove="dragMove">
            <GameTableHand ref="hand0" :player-index="0"/>
            <GameTableHand ref="hand1" :player-index="1"/>
            <GameTableHand ref="hand2" :player-index="2" v-if="playerCount >= 3"/>
            <GameTableHand ref="hand3" :player-index="3" v-if="playerCount >= 4"/>

            <GameTableCenterPile ref="centerPile"/>
        </div>
        <playing-card-deck v-show="status === 'setup'" ref="cardDeck"/>
    </div>
</template>

<script>
  import axios               from 'axios';
  import GameTableHand       from './GameTableHand';
  import GameTableCenterPile from './GameTableCenterPile';
  import PlayingCardDeck     from './PlayingCardDeck';

  export default {
    components: {GameTableHand, GameTableCenterPile, PlayingCardDeck},
    computed:   {
      hands() {
        return Object.keys(this.$refs)
          .filter(key => key.includes('hand'))
          .map((key) => {
            return this.$refs[key];
          });
      },

      playerHand() {
        return this.hands[0];
      },

      centerPile() {
        return this.$refs['centerPile'];
      },

      allCards() {
        let cards = this.hands.reduce((acc, hand) => {
          return acc.concat(hand.handCards.concat(hand.drawCards));
        }, []);
        cards     = cards.concat(this.centerPile.allCards);
        cards.reverse().forEach((card, index) => card.setOrder(index + 10));
        return cards;
      },
      playerCount() {
        return 2;
      }
    },

    mounted() {
      this.fetchRoundData()
        .then(() => this.$refs['cardDeck'].dealCards())
        .then(() => this.status = 'game');
      //   .then(this.stackDeck)
      //   .then(this.dealHands)
      //   .then(this.centerPile.dealCards)
      //   .then(this.revealCards)
      //   .then(() => this.status = 'game');
    },

    data() {
      return {roundData: {}, isDragging: undefined, status: 'setup'};
    },

    methods: {
      fetchRoundData() {
        return new Promise((resolve) => {
          axios.get('/rounds/' + this.roundId + '.json').then((response) => {
            this.parseRoundData(response.data);
            resolve();
          });
        });
      },

      parseRoundData(round) {
        this.roundData = round;
        this.hands.forEach((hand, index) => hand.setHandData(round.data.hands[index]));
        this.centerPile.setCardData(round.data);
      },

      isPlayerCard(card) {
        return this.playerHand.handCards.includes(card);
      },

      dragStart(ev) {
        let card = ev.target.__vue__;
        if (this.isPlayerCard(card) && this.status === 'game') {
          if (this.isDragging) this.isDragging.endDrag();
          this.isDragging = card;
          card.startDrag();
        }
      },

      dragEnd() {
        if (this.isDragging) {
          let card = this.isDragging;
          if (this.centerPile.isCardOverLeftPile(card)) this.playCard(card, 0);
          if (this.centerPile.isCardOverRightPile(card)) this.playCard(card, 1);
          this.isDragging.endDrag();
          this.isDragging = undefined;
        }
      },

      dragMove(ev) {
        if (this.isDragging) {
          this.isDragging.dragMove(ev);
        }
      },

      playCard(card, pileIndex) {
        let cardIndex = this.playerHand.indexOfCard(card);
        this.playerHand.removeCard(card)
          .then((cardData) => this.submitPlay(cardData, pileIndex))
          .then((cardData) => this.centerPile.place(cardData, pileIndex))
          .then(() => this.playerHand.pullFromDraw(cardIndex));
      },

      submitPlay(cardData, pileIndex) {
        return new Promise((resolve) => {
          // TODO: Submit to Rails and abort play if move is invalid
          resolve(cardData);
        });
      }
    },
    props:   {
      roundId: {type: String, required: true}
    }
  };
</script>