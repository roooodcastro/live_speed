export default {
  play(audioName, volume = 1.0) {
    return volume;
    // const audio  = new Audio(audioName);
    // audio.volume = volume;
    // return audio.play();
  },

  playDealCard() {
    // const number    = Math.floor(Math.random() * 2) + 1;
    // const audioFile = 'assets/cardPlace' + number + '.wav';
    // this.play(audioFile, 0.1);
  },

  cardPlaceAudios() {
    // const files = Array.from(Array(4).keys()).forEach((i) => 'assets/cardPlace' + i + '.wav');
    // return files.map((fileName) => {
    //   return newAudio(fileName);
    // });
  }
};
