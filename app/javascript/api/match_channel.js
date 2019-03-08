import createChannel from 'helpers/cable';
import I18n          from 'vendor/i18n-js-game.js.erb';

export default {
  subscribeToApi(gameTable) {
    return createChannel({ channel: 'MatchChannel', round_id: gameTable.roundId }, {
      // Called when the subscription is ready for use on the server.
      connected() {
        this.fetchData();
      },

      // Called when the subscription has been terminated by the server.
      disconnected() {
      },

      // Called when the subscription is rejected by the server.
      rejected() {
      },

      // Called when there's incoming data on the websocket for this channel
      received(data) {
        if (data.action === 'error') {
          alert(I18n.t('game.error', { error: data.message }));
        } else {
          const callbackName = ('on_' + data.action).toCamelCase();
          gameTable[callbackName](data);
        }
      },

      fetchData() {
        this.perform('fetch_data');
      },

      markReady(playerId) {
        this.perform('player_ready', { player_id: playerId });
      },

      playCard(cardIndex, pileIndex, playerId) {
        this.perform('play_card', { card_index: cardIndex, pile_index: pileIndex, player_id: playerId });
      },

      playReplacementPile(playerId) {
        this.perform('play_replacement', { player_id: playerId });
      }
    });
  }
};
