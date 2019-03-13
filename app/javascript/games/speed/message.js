import I18n from 'vendor/i18n-js-game.js.erb';

export default {
  generate(round, state, playerId) {
    switch (state) {
      case 'setup':
        return this.setupMessage(round, playerId);
      case 'game':
        return this.gameMessage(round, playerId);
      case 'win':
        return 'Congratulations, you have won this round!';
      case 'lose':
        return 'You have lost this round...';
    }
    return '';
  },

  setupStateVars(round, playerId) {
    const playerReady    = round.hands.filter(hand => hand.player.id === playerId)[0].player.ready_to_play;
    const opponentsReady = round.hands
      .filter(hand => hand.player.id !== playerId)
      .reduce((ready, hand) => ready && hand.player.ready_to_play, true);
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

    if (!vars.ready) return I18n.t('game.message.setup.click_ready');
    if (vars.opponentsReady) return I18n.t('game.message.setup.starting');

    return I18n.t('game.message.setup.waiting');
  },

  gameMessage(round, playerId) {
    const vars = this.gameStateVars(round, playerId);

    if (!vars.canPlayReplacement) return '';
    if (!vars.ready) return I18n.t('game.message.play.no_plays');
    if (vars.opponentsReady) return I18n.t('game.message.play.drawing');

    return I18n.t('game.message.play.waiting');
  },

  invalidPlay() {
    return I18n.t('game.message.play.invalid_play');
  },

  invalidReplacement() {
    return I18n.t('game.message.play.invalid_rep');
  },

  playerConnected(playerName) {
    return I18n.t('game.message.play.connected', { name: playerName });
  },

  playerDisconnected(playerName) {
    return I18n.t('game.message.play.disconnected', { name: playerName });
  }
};
