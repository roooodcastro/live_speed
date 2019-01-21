<template>
    <div class="game-table-hand">
        <livespeed-playing-card v-for="(card, index) in centerPiles[0]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[-10, 0]"
                                :ref="'center_left_' + index"
                                :key="'center_left_' + index"/>
        <livespeed-playing-card v-for="(card, index) in centerPiles[1]"
                                :suit="card.s"
                                :rank="card.r"
                                :initial-position="[10, 0]"
                                :ref="'center_right_' + index"
                                :key="'center_right_' + index"/>
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

  const DEFAULT_DELAY = 10;

  export default {
    computed: {
      allCards() {
        return this.$children;
      },
      leftCenterPileCount() {
        return this.centerPiles[0].length;
      },
      rightCenterPileCount() {
        return this.centerPiles[1].length;
      },
      leftRepPileCount() {
        return this.replacementPiles[0].length;
      },
      rightRepPileCount() {
        return this.replacementPiles[1].length;
      },
    },

    data() {
      return {centerPiles: [], replacementPiles: []};
    },

    mounted() {
    },

    updated() {
      // this.dealCards(0);
    },

    methods: {
      moveCard(card, position, delay) {
        return new Promise((resolve) => {
          card.move(position);

          setTimeout(() => resolve(), delay);
        });
      },

      dealCenterPileCard(pileIndex, cardIndex, delay) {
        let mult       = (pileIndex === 0) ? -1 : 1;
        let posY       = cardIndex * -0.2;
        let posX       = 10 * mult;
        let leftCards  = this.filterCards('center_left');
        let rightCards = this.filterCards('center_right');
        let card       = (pileIndex === 0) ? leftCards[cardIndex] : rightCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], delay);
      },

      dealRepPileCard(pileIndex, cardIndex, delay) {
        let mult       = (pileIndex === 0) ? 1 : -1;
        let posY       = cardIndex * -0.2;
        let posX       = 40 * mult;
        let leftCards  = this.filterCards('replacement_left');
        let rightCards = this.filterCards('replacement_right');
        let card       = (pileIndex === 0) ? leftCards[cardIndex] : rightCards[cardIndex];
        card.setOrder(cardIndex + 100);
        AudioManager.playDealCard();

        return this.moveCard(card, [posX, posY], delay);
      },

      dealCards(delay = DEFAULT_DELAY) {
        return new Promise((resolve) => {
          let center1Dealer = (promise, index) => promise.then(() => this.dealCenterPileCard(0, index, delay));
          let center2Dealer = (promise, index) => promise.then(() => this.dealCenterPileCard(1, index, delay));
          let rep1Dealer    = (promise, index) => promise.then(() => this.dealRepPileCard(0, index, delay));
          let rep2Dealer    = (promise, index) => promise.then(() => this.dealRepPileCard(1, index, delay));
          let promise       = this.expandArray(this.leftRepPileCount).reduce(rep1Dealer, Promise.resolve());
          promise           = this.expandArray(this.rightRepPileCount).reduce(rep2Dealer, promise);
          promise           = this.expandArray(this.leftCenterPileCount).reduce(center1Dealer, promise);
          return this.expandArray(this.rightCenterPileCount).reduce(center2Dealer, promise).then(() => resolve());
        });
      },

      revealCards() {
        return new Promise((resolve) => {
          this.filterCards('center_left').forEach((card) => card.flipUp());
          this.filterCards('center_right').forEach((card) => card.flipUp());
          setTimeout(() => resolve(), 500);
        });
      },

      setCardData(data) {
        this.centerPiles      = data.central_pile.piles;
        this.replacementPiles = data.replacement_piles;
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
      },

      place(cardData, pileIndex) {
        let newPile = this.centerPiles[pileIndex].concat([cardData]);
        this.centerPiles.splice(pileIndex, 1, newPile);

        Vue.nextTick(() => {
          this.dealCards(0).then(this.revealCards);
        });
      },

      expandArray(number) {
        return Array.from(Array(number).keys());
      }
    }
  };
</script>
