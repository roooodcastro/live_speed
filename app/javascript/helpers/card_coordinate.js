import screen                                 from './screen';
import { GRID_SIZE, CARD_WIDTH, CARD_HEIGHT } from '../constants';

export default class CardCoordinate {
  constructor(posX, posY, scale) {
    if (posX.constructor === Array) {
      this.x     = posX[0];
      this.y     = posX[1];
      this.scale = posY;
    } else {
      this.x     = posX;
      this.y     = posY;
      this.scale = scale;
    }
  }

  static coordSize() {
    return screen.smallerScreenSize() / GRID_SIZE;
  }

  static cardScale() {
    let clientW = screen.clientWidth();
    let clientH = screen.clientHeight();
    if (clientW > clientH) {
      let smallerSize  = CARD_WIDTH;
      let targetHeight = (100 * CardCoordinate.coordSize()) / 5;
      return targetHeight / smallerSize;
    } else {
      let smallerSize = CARD_HEIGHT;
      let targetWidth = (200 * CardCoordinate.coordSize()) / 6;
      return targetWidth / smallerSize;
    }
  }

  get pxString() {
    return this.xPixels + 'px,' + this.yPixels + 'px';
  }

  get xPixels() {
    let relativePos  = this.x * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[0];
    let gridOffset = this.cardGridOffset(this.x, CARD_WIDTH);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  get yPixels() {
    let relativePos  = this.y * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[1];
    let gridOffset = this.cardGridOffset(this.y, CARD_HEIGHT);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  add(other) {
    return new CardCoordinate(this.x + other.x, this.y + other.y);
  }

  cardGridOffset(cardPos, cardSize) {
    let cardCenterOffset = (((cardSize * this.scale) - cardSize) / 2);
    let gridEndOffset    = cardSize * ((cardPos + (GRID_SIZE / 2)) / GRID_SIZE) * this.scale;
    return cardCenterOffset - gridEndOffset;
  }
}
