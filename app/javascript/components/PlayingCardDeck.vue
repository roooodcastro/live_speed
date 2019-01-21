<template>
    <div>
        <livespeed-playing-card v-for="(index, card) in cards"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[0, 0 - (index * 0.2)"/>
    </div>
</template>

<script>
  export default {
    data() {
      return {
        cards:         this.createCards(),
        cardPositions: [
          {pos: [-40, 80], rot: 0, count: 1},
          {pos: [-25, 80], rot: 0, count: 1},
          {pos: [-10, 80], rot: 0, count: 1},
          {pos: [5, 80], rot: 0, count: 1},
          {pos: [20, 80], rot: 0, count: 1},
          {pos: [40, 80], rot: 0, count: 15},
          {pos: [-40, -80], rot: 180, count: 1},
          {pos: [-25, -80], rot: 180, count: 1},
          {pos: [-10, -80], rot: 180, count: 1},
          {pos: [5, -80], rot: 180, count: 1},
          {pos: [20, -80], rot: 180, count: 1},
          {pos: [40, -80], rot: 180, count: 15}
        ]
      };
    },
    props:   {
      cardCount: {type: Number, default: 52}
    },
    methods: {
      createCards() {
        return [...Array(this.cardCount)].map(() => ({r: 'a', s: 's'}));
      },

      dealCard(cardIndex, position, rotation) {
        let card = this.$children[index];
        return new Promise((resolve) => {
          card.move(position);
          card.rotate(rotation);

          setTimeout(() => resolve(), 50);
        });
      },

      dealCards() {
        let dealer = (promise, info, index) => {
          promise.then(() => this.dealCard(this.cardCount - (index + 1), info.pos, info.rot));
        };

        let allCardsInfo = this.cardPositions.reduce((acc, info) => acc.concat(Array(info.count).fill(info)));
        allCardsInfo.reduce(dealer, Promise.resolve());
      }
    }
  };
</script>
