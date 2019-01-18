<template>
    <div class="game-table-hand">
        <livespeed-playing-card :ref="'card' + playerIndex + '1'"/>
        <livespeed-playing-card :ref="'card' + playerIndex + '2'"/>
        <livespeed-playing-card :ref="'card' + playerIndex + '3'"/>
        <livespeed-playing-card :ref="'card' + playerIndex + '4'"/>
        <livespeed-playing-card :ref="'card' + playerIndex + '5'"/>
    </div>
</template>

<script>
  export default {
    computed: {
      cards() {
        return this.$children;
      }
    },
    data() {
      return {};
    },
    mounted() {
    },
    props: {
      playerIndex: {type: Number, required: true}
    },
    methods: {
      dealCard(cardIndex, delay) {
        return new Promise((resolve) => {
          let mult = (this.playerIndex === 0) ? 1 : -1;
          let posY = 80 * mult;
          let posIndex = cardIndex - 2;
          let posX = ((15 * posIndex) - 10) * mult;
          let card = this.cards[cardIndex];
          card.move([posX, posY]);
          card.rotate(this.playerIndex * 180);

          setTimeout(() => resolve(), delay);
        });
      },
      dealCards() {
        return new Promise((resolve) => {
          let delay = 100;
          let dealer = (promise, index) => promise.then(() => this.dealCard(index, delay));
          Array.from(Array(5).keys()).reduce(dealer, Promise.resolve()).then(() => resolve());
        });
      },
      setHandData(data) {

      }
    }
  }
</script>