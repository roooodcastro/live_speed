import cardPlace1 from '../audios/cardPlace1.wav';
import cardPlace2 from '../audios/cardPlace2.wav';
import cardPlace3 from '../audios/cardPlace3.wav';
import cardPlace4 from '../audios/cardPlace4.wav';

const AUDIOS = [
  cardPlace1,
  cardPlace2,
  cardPlace3,
  cardPlace4,
];

export default {
  play(audioName, volume = 1.0) {
    const audio  = new Audio(audioName);
    audio.volume = volume;
    return audio.play();
  },

  playDealCard() {
    const number    = Math.floor(Math.random() * 2);
    const audioFile = AUDIOS[number];
    this.play(audioFile, 0.1);
  },

  cardPlaceAudios() {
    // const files = Array.from(Array(4).keys()).forEach((i) => 'assets/cardPlace' + i + '.wav');
    // return files.map((fileName) => {
    //   return newAudio(fileName);
    // });
  },
};
