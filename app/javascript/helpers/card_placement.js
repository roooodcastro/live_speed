export default {
// Returns an array containing all the static card positions, including the positions for the hands and center piles.
  allCardPositions(numberOfPlayers) {
    let playerIndices = Array.from(Array(numberOfPlayers).keys());
    let hands = playerIndices.reduce((acc, index) => {
      return acc.concat(this.handPositions(index, numberOfPlayers));
    }, []);

    let centerDistanceFactor = (numberOfPlayers === 2) ? 1 : 0.7;
    let centerPiles = [
      { pos: [centerDistanceFactor * -80, 0], rot: 0 },
      { pos: [centerDistanceFactor * 80, 0], rot: 0 },
      { pos: [centerDistanceFactor * -20, 0], rot: 0 },
      { pos: [centerDistanceFactor * 20, 0], rot: 0 }
    ];

    return hands.concat(centerPiles);
  },

  handPositions(playerIndex, numberOfPlayers) {
    let basePositions = [-80, -48, -16, 16, 48, 80];
    let rotation = playerIndex * -(360 / numberOfPlayers);
    let distanceFactor = (numberOfPlayers === 2) ? 1 : 0.8;

    if (numberOfPlayers === 2) {
      let mult = (playerIndex === 0) ? 1 : -1;
      return basePositions.map((pos) => ({ pos: [pos * mult, 95 * mult], rot: rotation }));
    } else {
      let multIndex = (playerIndex % 2 === 0) ? 0 : 3;
      let mult = (playerIndex === multIndex) ? 1 : -1;
      let positionFunc = (pos, mult) => {
        let positionHoriz = [pos * mult * distanceFactor, 95 * mult];
        let positionVert = [-95 * mult, pos * mult * distanceFactor];
        return (multIndex === 0) ? positionHoriz : positionVert;
      };

      return basePositions.map((pos) => ({ pos: positionFunc(pos, mult), rot: rotation }));
    }
  }
};
