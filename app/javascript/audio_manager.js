export default {
  play(audioName, volume = 1.0) {
    let audio = new Audio(audioName);
    audio.volume = volume;
    // return audio.play();
  },

  playDealCard() {
    let number = Math.floor(Math.random() * 2) + 1;
    let audioFile = 'assets/cardPlace' + number + '.wav';
    this.play(audioFile, 0.1);
  },

  cardPlaceAudios() {
    let files = Array.from(Array(4).keys()).forEach((i) => 'assets/cardPlace' + i + '.wav');
    return files.map((fileName) => {
      return newAudio(fileName);
    })
  }
};
