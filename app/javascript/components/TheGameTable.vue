<template>
    <div id="game_table" class="game-table-container">
        <livespeed-playing-card :initial-position="[-40, -80]"/>

        <GameTableHand ref="hand0" :player-index="0"/>
        <GameTableHand ref="hand1" :player-index="1"/>
        <!--<GameTableHand :player-index="2" />-->
        <!--<GameTableHand :player-index="3" />-->

        <livespeed-playing-card :initial-position="[-40, 0]"/>
        <livespeed-playing-card :initial-position="[-10, 0]"/>
        <livespeed-playing-card :initial-position="[10, 0]"/>
        <livespeed-playing-card :initial-position="[40, 0]"/>

        <livespeed-playing-card :initial-position="[40, 80]"/>
    </div>
</template>

<script>
  import axios         from 'axios';
  import GameTableHand from './GameTableHand';

  export default {
    components: {GameTableHand},
    computed:   {
      hands() {
        return [this.$refs['hand1'], this.$refs['hand0']];
      }
    },
    mounted() {
      this.fetchRoundData()
        .then(this.dealHands);
    },
    data() {
      return {roundData: {}};
    },
    methods:    {
      moveCard(card, position) {
        card.move(position);
      },
      dealHands() {
        return new Promise((resolve) => {
          let dealer = (promise, hand) => promise.then(() => hand.dealCards());
          this.hands.reduce(dealer, Promise.resolve()).then(() => resolve());
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
      }
    },
    props:      {
      roundId: {type: String, required: true}
    }
  };
</script>