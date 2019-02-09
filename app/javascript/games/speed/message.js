export default {
  generate(round, state, playerId) {
    switch (state) {
      case 'setup':
        return this.setupMessage(round, playerId);
      case 'game':
        return this.gameMessage(round, playerId);
    }
    return '';
  },

  setupStateVars(round, playerId) {
    const playerReady    = round.hands.filter(hand => hand.player.id === playerId)[0].player.ready;
    const opponentsReady = round.hands
      .filter(hand => hand.player.id !== playerId)
      .reduce((ready, hand) => ready && hand.player.ready, true);
    return { ready: playerReady, opponentsReady: opponentsReady };
  },

  gameStateVars(round, playerId) {
    const playerReady    = round.hands.filter(hand => hand.player.id === playerId)[0].player.ready_replacement;
    const opponentsReady = round.hands
      .filter(hand => hand.player.id !== playerId)
      .reduce((ready, hand) => ready && hand.player.ready_replacement, true);

    return { canPlayReplacement: round.can_use_replacement, ready: playerReady, opponentsReady: opponentsReady };
  },

  setupMessage(round, playerId) {
    const vars = this.setupStateVars(round, playerId);

    if (!vars.ready) return 'Click READY to start the round:';
    if (vars.opponentsReady) return 'Round starting...';

    return 'Waiting for opponent(s)...';
  },

  gameMessage(round, playerId) {
    const vars = this.gameStateVars(round, playerId);

    if (!vars.canPlayReplacement) return '';
    if (!vars.ready) return 'There are no plays left! Click on the replacement pile to your right to use it!';
    if (vars.opponentsReady) return 'Drawing cards from the replacement piles...';

    return 'Waiting for opponent(s)...';
  }
};