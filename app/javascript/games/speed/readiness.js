export default class {
  // players is assumed to be an array containing either 2 or 4 players, having the first player (index 0) always be
  // this browser client's player.
  constructor(players, name) {
    this.players  = players;
    this.name     = name;
  }

  get player() {
    return this.players[0];
  }

  get opponents() {
    return this.players.slice(1);
  }

  get playerReady() {
    return this.player[this.name];
  }

  get opponentsReady() {
    return this.opponents.reduce((ready, opponent) => ready && opponent[this.name], true);
  }

  get allPlayersReady() {
    return this.playerReady && this.opponentsReady;
  }
}
