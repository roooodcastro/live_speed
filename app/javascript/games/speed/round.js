import Readiness from 'games/speed/readiness';

export default class {
  constructor(playerId, api, onStatusChange) {
    this.playerId       = playerId;
    this.onStatusChange = onStatusChange;
    this.api            = api;
    this.readyToPlay    = new Readiness(this.players, 'ready_to_play');
    this.readyToReplace = new Readiness(this.players, 'ready_to_replace');
  }

  // Checks all of the round's data to determine the appropriate state for this stage of the game
  get state() {
    if (!this.data) return 'loading';
    if (!this.readyToPlay.allPlayersReady) return 'setup';
    if (this.canUseReplacement) return 'staled_game';
    if (this.winner) return (this.winnerId === this.playerId) ? 'win' : 'lose';

    return 'game';
  }

  get allPlayersReady() {
    return this.readyToPlay.allPlayersReady;
  }

  get allOpponentsReady() {
    return this.readyToPlay.opponentsReady;
  }

  get players() {
    return this.hands.map(hand => hand.player);
  }

  get winner() {
    return this.hands.filter(hand => hand.player.id === this.winnerId)[0];
  }

  get hands() {
    if (!this.data) return [];
    return this.hands;
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
    this.data              = roundData;
    this.hands             = this.sortHands(roundData.hands);
    this.centerPiles       = roundData.central_pile.piles;
    this.replacementPiles  = roundData.replacement_piles;
    this.canUseReplacement = roundData.can_use_replacement;
    this.winnerId          = roundData.winner_id;
  }

  update(roundData) {
    this.data              = roundData;
    this.hands             = this.sortHands(roundData.hands);
    this.centerPiles       = roundData.central_pile.piles;
    this.replacementPiles  = roundData.replacement_piles;
    this.canUseReplacement = roundData.can_use_replacement;
    this.winnerId          = roundData.winner_id;
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
}
