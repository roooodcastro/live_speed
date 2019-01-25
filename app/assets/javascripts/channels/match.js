if (App.api && !App.api.consumer.connection.disconnected) {
  App.api.unsubscribe();
}

App.api = App.cable.subscriptions.create('MatchChannel', {
  // Called when the subscription is ready for use on the server.
  connected() {
    console.log('connected!');
    Vue.$refs['gameTable'].setupRound();
  },

  // Called when the subscription has been terminated by the server.
  disconnected() {
    console.log('server died');
  },

  // Called when the subscription is rejected by the server.
  rejected() {
  },

  received(data) {
    console.log(data.action);
    // Called when there's incoming data on the websocket for this channel
  },

  fetchData() {
    this.perform('fetch_data');
  },

  playCard(card, pileIndex) {
    this.perform('play_card', { card: card, pile_index: pileIndex });
  },

  playReplacementPile() {
    this.perform('play_replacement');
  }
});
