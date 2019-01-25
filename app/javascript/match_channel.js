export default {
  subscribeToApi(gameTable) {
    return App.cable.subscriptions.create('MatchChannel', {
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
        if (data.action === 'round_data') {
          gameTable.parseRoundData(data);
        }
      },

      fetchData(roundId) {
        this.perform('fetch_data', { round_id: roundId });
      },

      playCard(card, pileIndex) {
        this.perform('play_card', { card: card, pile_index: pileIndex });
      },

      playReplacementPile() {
        this.perform('play_replacement');
      }
    });
  }
}
