import AudioManager        from 'helpers/audio_manager';
import { CARD_DEAL_DELAY, } from 'helpers/constants';

export default {
// Returns an array containing all the static card positions, including the positions for the hands and center piles.
  allCardPositions(numberOfPlayers) {
    const playerIndices = Array.from(Array(numberOfPlayers).keys());
    const hands         = playerIndices.reduce((acc, index) => {
      return acc.concat(this.handPositions(index, numberOfPlayers));
    }, []);

    const centerDistanceFactor = (numberOfPlayers === 2) ? 1 : 0.6;
    const centerPiles          = [
      { pos: [centerDistanceFactor * -80, 0, ], rot: 0, },
      { pos: [centerDistanceFactor * 80, 0, ], rot: 0, },
      { pos: [centerDistanceFactor * -20, 0, ], rot: 0, },
      { pos: [centerDistanceFactor * 20, 0, ], rot: 0, },
    ];

    return hands.concat(centerPiles);
  },

  handPositions(playerIndex, numberOfPlayers) {
    const basePositions  = [-80, -48, -16, 16, 48, 80, ];
    const rotation       = playerIndex * -(360 / numberOfPlayers);
    const distanceFactor = (numberOfPlayers === 2) ? 1 : 0.675;

    if (numberOfPlayers === 2) {
      const mult = (playerIndex === 0) ? 1 : -1;
      return basePositions.map((pos) => ({ pos: [pos * mult, 75 * mult, ], rot: rotation, }));
    } else {
      const multIndex    = (playerIndex % 2 === 0) ? 0 : 3;
      const mult         = (playerIndex === multIndex) ? 1 : -1;
      const positionFunc = (pos, mult) => {
        const positionHoriz = [pos * mult * distanceFactor, 80 * mult, ];
        const positionVert  = [-80 * mult, pos * mult * distanceFactor, ];
        return (multIndex === 0) ? positionHoriz : positionVert;
      };

      return basePositions.map((pos) => ({ pos: positionFunc(pos, mult), rot: rotation, }));
    }
  },

  dealer(promise, cardInfo) {
    return promise.then(() => {
      return new Promise((resolve) => {
        const card = cardInfo.card;
        card.move(cardInfo.pos);
        card.rotate(cardInfo.rot || 0);
        card.setOrder(cardInfo.order || 1);
        if (cardInfo.flipDown) card.flipDown();
        if (cardInfo.flipUp) card.flipUp();
        AudioManager.playDealCard();

        setTimeout(() => resolve(), cardInfo.delay || CARD_DEAL_DELAY);
      });
    });
  },
};
