import createChannel from 'helpers/cable';

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
        switch (data.action) {
          case 'round_data':
            gameTable.onApiReceiveRoundData(data);
            break;
          case 'play_response':
            gameTable.onCardPlay(data);
            break;
          case 'replacement_response':
            gameTable.onReplacementResponse(data);
            break;
          case 'player_ready':
            gameTable.onPlayerReady(data);
            break;
          case 'player_connected':
            gameTable.onPlayerConnected(data);
            break;
          case 'player_disconnected':
            gameTable.onPlayerDisconnected(data);
            break;
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
