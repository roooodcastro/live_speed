export default {
  subscribeToApi(gameTable) {
    return App.cable.subscriptions.create({ channel: 'MatchChannel', round_id: gameTable.roundId }, {
      // Called when the subscription is ready for use on the server.
      connected() {
        console.log('connected!');
        gameTable.fetchRoundData();
      },

      // Called when the subscription has been terminated by the server.
      disconnected() {
        console.log('server died');
      },

      // Called when the subscription is rejected by the server.
      rejected() {
      },

      // Called when there's incoming data on the websocket for this channel
      received(data) {
        switch (data.action) {
          case 'round_data':
            gameTable.parseRoundData(data);
            break;
          case 'play_response':
            gameTable.processPlayResponse(data);
            break;
        }
      },

      fetchData() {
        this.perform('fetch_data');
      },

      playCard(cardIndex, pileIndex, playerId) {
        this.perform('play_card', { card_index: cardIndex, pile_index: pileIndex, player_id: playerId });
      },

      playReplacementPile() {
        this.perform('play_replacement');
      }
    });
  }
};
