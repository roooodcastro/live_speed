<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in centerPiles[0]"
                                :suit="card.s"
                                :rank="card.r"
                                :ref="'center_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in centerPiles[1]"
                                :suit="card.s"
                                :rank="card.r"
                                :ref="'center_right_' + index"/>
        <livespeed-playing-card v-for="(card, index) in replacementPiles[0]"
                                :rank="card.r"
                                :suit="card.s"
                                :ref="'replacement_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in replacementPiles[1]"
                                :rank="card.r"
                                :suit="card.s"
                                :ref="'replacement_right_' + index"/>
    </div>
</template>

<script>
  import Vue          from 'vue';
  import AudioManager from '../audio_manager';

  export default {
    computed: {
      allCards() {
        return this.leftRepPile.concat(this.rightRepPile, this.leftCenterCards, this.rightCenterCards);
      },

      leftCenterCards() {
        return this.filterCards('center_left');
      },

      rightCenterCards() {
        return this.filterCards('center_right');
      },

      leftRepPile() {
        return this.filterCards('replacement_left');
      },

      rightRepPile() {
        return this.filterCards('replacement_right');
      },
    },

    data() {
      return {centerPiles: [], replacementPiles: []};
    },

    mounted() {
    },

    methods: {
      moveCard(card, position, delay) {
        return new Promise((resolve) => {
          card.move(position);

          setTimeout(() => resolve(), delay);
        });
      },

      dealCenterPileCard(pileIndex, cardIndex, delay) {
        let mult = (pileIndex === 0) ? 1 : -1;
        let posY = cardIndex * -0.2;
        let posX = 10 * mult;
        let card = (pileIndex === 0) ? this.leftCenterCards[cardIndex] : this.rightCenterCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], delay);
      },

      dealRepPileCard(pileIndex, cardIndex, delay) {
        let mult = (pileIndex === 0) ? 1 : -1;
        let posY = cardIndex * -0.2;
        let posX = 40 * mult;
        let card = (pileIndex === 0) ? this.leftRepPile[cardIndex] : this.rightRepPile[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], delay);
      },

      dealCards() {
        return new Promise((resolve) => {
          let delay         = 150;
          let center1Dealer = (promise, index) => promise.then(() => this.dealCenterPileCard(0, index, delay));
          let center2Dealer = (promise, index) => promise.then(() => this.dealCenterPileCard(1, index, delay));
          let rep1Dealer    = (promise, index) => promise.then(() => this.dealRepPileCard(0, index, delay));
          let rep2Dealer    = (promise, index) => promise.then(() => this.dealRepPileCard(1, index, delay));
          let promise       = Array.from(Array(5).keys()).reduce(rep1Dealer, Promise.resolve());
          promise           = Array.from(Array(5).keys()).reduce(rep2Dealer, promise);
          promise           = Array.from(Array(1).keys()).reduce(center1Dealer, promise);
          return Array.from(Array(1).keys()).reduce(center2Dealer, promise).then(() => resolve());
        });
      },

      revealCards() {
        return new Promise((resolve) => {
          this.leftCenterCards.forEach((card) => card.flipUp());
          this.rightCenterCards.forEach((card) => card.flipUp());
          setTimeout(() => resolve(), 500);
        });
      },

      setCardData(data) {
        this.centerPiles      = data.central_pile.piles;
        this.replacementPiles = data.replacement_piles;

        Vue.nextTick(() => {
          this.leftCenterCards.forEach((card, index) => card.setRankSuit(data.central_pile.piles[0][index]));
          this.rightCenterCards.forEach((card, index) => card.setRankSuit(data.central_pile.piles[1][index]));
          this.leftRepPile.forEach((card, index) => card.setRankSuit(data.replacement_piles[0][index]));
          this.rightRepPile.forEach((card, index) => card.setRankSuit(data.replacement_piles[1][index]));
        });
      },

      filterCards(ref) {
        return Object.keys(this.$refs)
          .filter(key => key.includes(ref))
          .map((key) => {
            let ref = this.$refs[key];
            return Array.isArray(ref) ? ref[0] : ref;
          });
      },

      cardOverLeftPile(card) {
        let insideX = Math.abs(card.dragPosition[0] + 10) < card.widthVw * 1.5 && card.dragPosition[0] < 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      },

      cardOverRightPile(card) {
        let insideX = Math.abs(card.dragPosition[0] - 10) < card.widthVw * 1.5 && card.dragPosition[0] > 0;
        let insideY = Math.abs(card.dragPosition[1]) < card.heightVh * 2;
        return insideX && insideY;
      }
    }
  };
</script>
