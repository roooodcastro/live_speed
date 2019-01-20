<template>
    <div id="game_table" class="game-table-container" @mousedown="dragStart" @mouseup="dragEnd" @mousemove="dragMove">
        <GameTableHand ref="hand0" :player-index="0"/>
        <GameTableHand ref="hand1" :player-index="1"/>
        <GameTableHand ref="hand2" :player-index="2" v-if="playerCount >= 3"/>
        <GameTableHand ref="hand3" :player-index="3" v-if="playerCount >= 4"/>

        <GameTableCenterPile ref="centerPile"/>
        <!--<livespeed-playing-card :initial-position="[-40, 0]"/>-->
        <!--<livespeed-playing-card :initial-position="[-10, 0]"/>-->
        <!--<livespeed-playing-card :initial-position="[10, 0]"/>-->
        <!--<livespeed-playing-card :initial-position="[40, 0]"/>-->
    </div>
</template>

<script>
  import axios               from 'axios';
  import GameTableHand       from './GameTableHand';
  import GameTableCenterPile from './GameTableCenterPile';

  export default {
    components: {GameTableHand, GameTableCenterPile},
    computed:   {
      hands() {
        return Object.keys(this.$refs)
          .filter(key => key.includes('hand'))
          .map((key) => {
            return this.$refs[key];
          });
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
        .then(this.stackDeck)
        .then(this.dealHands)
        .then(this.centerPile.dealCards)
        .then(this.revealCards)
        .then(() => this.status = 'game');
    },

    data() {
      return {roundData: {}, isDragging: undefined, status: 'setup'};
    },

    methods:    {
      stackDeck() {
        return new Promise((resolve) => {
          this.allCards.forEach((card, index) => card.move([0, index * -0.2]));
          setTimeout(() => resolve(), 500);
        });
      },

      dealHands() {
        return new Promise((resolve) => {
          let dealer = (promise, hand) => promise.then(() => hand.dealCards());
          this.hands.reduce(dealer, Promise.resolve()).then(() => resolve());
        });
      },

      revealCards() {
        return new Promise((resolve) => {
          this.hands.forEach((hand) => hand.revealCards());
          this.centerPile.revealCards();
          setTimeout(() => resolve(), 500);
        });
      },

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
        return this.hands[0].handCards.includes(card);
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
          if (this.centerPile.cardOverLeftPile(card)) this.playCard(card, 0);
          if (this.centerPile.cardOverRightPile(card)) this.playCard(card, 1);
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
        alert('card played at ' + pileIndex);
      }
    },
    props:      {
      roundId: {type: String, required: true}
    }
  };
</script>