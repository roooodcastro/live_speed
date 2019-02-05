export default class {
  // players is assumed to be an array containing either 2 or 4 players, having the first player (index 0) always be
  // this browser client's player.
  constructor(data, players, name) {
    this.data     = data;
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
    return player[name];
  }

  get opponentsReady() {
    return opponents.reduce((ready, opponent) => ready && opponent[name], true);
  }

  get allPlayersReady() {
    return this.isPlayerReady() && this.areOpponentsReady();
  }
}