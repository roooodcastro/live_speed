import apiClient from 'api/match_channel';

export default class {
  constructor(playerId, onStatusChange) {
    this._status        = 'loading';
    this.playerId       = playerId;
    this.onStatusChange = onStatusChange;
    this.api            = apiClient.subscribeToApi(this);
  }

  get loaded() {
    return !!this.roundData;
  }

  get status() {
    return this._status;
  }

  set status(newStatus) {
    this.onStatusChange(this._status, newStatus);
    this._status = newStatus;
  }

  loadData(roundData) {
    this.status           = 'setup';
    this.roundData        = roundData;
    this.hands            = this.sortHands(roundData.hands);
    this.centerPiles      = roundData.central_pile.piles;
    this.replacementPiles = roundData.replacement_piles;
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
}
