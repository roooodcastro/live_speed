import Readiness from 'games/speed/readiness';

export default class {
  static parseRoundData(roundData, playerId) {
    roundData.hands   = this.sortHands(roundData.hands, playerId);
    roundData.players = roundData.hands.map(hand => hand.player);
    return roundData;
  }

  static sortHands(hands, playerId) {
    return hands.sort((h1, h2) => {
      if (h1.player.id === playerId) {
        return -1;
      } else if (h2.player.id === playerId) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  static state(roundData, playerId) {
    if (!roundData || !roundData.hands) return 'loading';
    if (!new Readiness(roundData.players, 'ready_to_play').allPlayersReady) return 'setup';
    if (roundData.canUseReplacement) return 'staled_game';
    if (roundData.winner_id) return (roundData.winner_id === playerId) ? 'win' : 'lose';

    return 'game';
  }

  constructor(playerId, onStatusChange) {
    this.playerId       = playerId;
    this.onStatusChange = onStatusChange;
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

  get allReadyToReplace() {
    return this.readyToReplace.allPlayersReady;
  }

  get players() {
    return this.hands.map(hand => hand.player);
  }

  get winner() {
    return this.hands.filter(hand => hand.player.id === this.winnerId)[0];
  }

  get hands() {
    if (!this.data) return [];
    return this._hands;
  }

  get loaded() {
    return !!this.data;
  }

  set state(newState) {
    return new Promise(resolve => {
      const oldState = this._state;
      this._state    = newState;
      this.onStatusChange(oldState, newState);
      resolve();
    });
  }

  updateData(roundData) {
    this.data              = roundData;
    this._hands            = roundData.hands;
    this.centerPiles       = roundData.central_pile.piles;
    this.replacementPiles  = roundData.replacement_piles;
    this.canUseReplacement = roundData.can_use_replacement;
    this.winnerId          = roundData.winner_id;
    this.readyToPlay       = new Readiness(this.players, 'ready_to_play');
    this.readyToReplace    = new Readiness(this.players, 'ready_to_replace');
  }

  playerHand(playerId) {
    return this.hands.filter((hand) => hand.player.id === playerId)[0];
  }
}
