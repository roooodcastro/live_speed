import Message from 'games/speed/message';

export default class {
  constructor(playerId, api, onStatusChange, onPlayerMessage) {
    this._state          = 'loading';
    this.playerId        = playerId;
    this.onStatusChange  = onStatusChange;
    this.onPlayerMessage = onPlayerMessage;
    this.api             = api;
  }

  get allPlayersReady() {
    return this.players.reduce((ready, player) => ready && player.ready, true);
  }

  get allOpponentsReady() {
    return this.opponents.reduce((ready, player) => ready && player.ready, true);
  }

  get state() {
    return this._state;
  }

  get players() {
    return this.hands.map(hand => hand.player);
  }

  get player() {
    return this.hands[0].player;
  }

  get opponents() {
    return this.players.slice(1);
  }

  set state(newState) {
    return new Promise(resolve => {
      const oldState = this._state;
      this._state    = newState;
      this.onStatusChange(oldState, newState);
      resolve();
    });
  }

  loadData(roundData) {
    this.roundData         = roundData;
    this.hands             = this.sortHands(roundData.hands);
    this.centerPiles       = roundData.central_pile.piles;
    this.replacementPiles  = roundData.replacement_piles;
    this.canUseReplacement = roundData.can_use_replacement;
    this.state             = 'setup';
  }

  sortHands(hands) {
    return hands.sort((h1, h2) => {
      if (h1.player.id === this.playerId) {
        return -1;
      } else if (h2.player.id === this.playerId) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  setPlayerAsReady(playerId) {
    this.hands.forEach(hand => {
      if (hand.player.id === playerId) hand.player.ready = true;
    });
    if (this.allPlayersReady) this.state = 'game';
  }

  setPlayerMessage() {
    if (this.canUseReplacement) {
      this.onPlayerMessage('There are no plays left! Use the replacement pile to your right!');
    }
  }
}
