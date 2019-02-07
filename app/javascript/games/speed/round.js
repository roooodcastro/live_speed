import Readiness from 'games/speed/readiness';

export default class {
  constructor(playerId, api, onStatusChange) {
    this._state         = 'loading';
    this.playerId       = playerId;
    this.onStatusChange = onStatusChange;
    this.api            = api;
    this.readyToPlay    = new Readiness(this.players, 'ready_to_play');
    this.readyToReplace = new Readiness(this.players, 'ready_to_replace');
  }

  // Checks all of the round's data to determine the appropriate state for this stage of the game
  get state2() {
    // TODO: Check how I can determine the "setup" state, which is when the cards are being dealt (might be a local state only)
    if (!this.data) return 'loading';
    // TODO: rename this state, because players are not ready in the "ready" state, d'oh
    if (!this.readyToPlay.allPlayersReady) return 'ready';
    if (this.canUseReplacement) return 'staled_game';
    // TODO: Determine if the game is over
    if (false) return 'game'; // New state for when the players can only play from the replacement piles.

    // TODO: Determine end-game state
    if (false) return 'win';
    return 'lose';
  }

  get allPlayersReady() {
    return this.readyToPlay.allPlayersReady;
  }

  get allOpponentsReady() {
    return this.readyToPlay.opponentsReady;
  }

  get state() {
    return this._state;
  }

  get players() {
    return this.hands.map(hand => hand.player);
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
