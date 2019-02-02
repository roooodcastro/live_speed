export default {
  subscribeToApi(gameTable) {
    return App.cable.subscriptions.create({ channel: 'MatchChannel', round_id: gameTable.roundId }, {
      // Called when the subscription is ready for use on the server.
      connected() {
        console.log('connected!');
        this.fetchData();
      },

      // Called when the subscription has been terminated by the server.
      disconnected() {
        console.log('server died');
      },

      // Called when the subscription is rejected by the server.
      rejected() {
        console.log('server didn\'t like me :(');
      },

      // Called when there's incoming data on the websocket for this channel
      received(data) {
        switch (data.action) {
          case 'round_data':
            gameTable.onApiReceiveData(data);
            break;
          case 'play_response':
            gameTable.onCardPlay(data);
            break;
          case 'player_ready':
            gameTable.onPlayerReady(data);
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

      playReplacementPile() {
        this.perform('play_replacement');
      }
    });
  }
};
