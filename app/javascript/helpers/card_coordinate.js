import screen                                 from './screen';
import { GRID_SIZE, CARD_WIDTH, CARD_HEIGHT } from '../constants';

export default class CardCoordinate {
  constructor(posX, posY) {
    if (posX.constructor === Array) {
      this.x = posX[0];
      this.y = posX[1];
    } else {
      this.x = posX;
      this.y = posY;
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

  static cardGridOffset(cardPos, cardSize) {
    let cardCenterOffset = (((cardSize * CardCoordinate.cardScale) - cardSize) / 2);
    let gridEndOffset    = cardSize * ((cardPos + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale;
    return cardCenterOffset - gridEndOffset;
  }

  // Transforms a pixel position array (in the format [x, y]) into a CardCoordinate. If the pixel position
  // is outside of the grid (if the coordinate value is outside the range -100..100), it will bound the coordinate to
  // the grid size, so the return values will always stay within -100..100.
  static fromPixelPosition(xPixels, yPixels) {
    // Formula: inverse the formula to transform coord into pixels
    // pixels = (screenCenter + (coord * coordSize) + gridOffset) / scale;
    // becomes
    // coord =  (pixels * scale - (screenCenter + gridOffset)) / coordSize

    let adjustedPixelScaleX = xPixels * CardCoordinate.cardScale();
    let adjustedPixelScaleY = yPixels * CardCoordinate.cardScale();
    let gridOffsetX         = CardCoordinate.cardGridOffset(xPixels, CARD_WIDTH) + screen.centerPosition()[0];
    let gridOffsetY         = CardCoordinate.cardGridOffset(yPixels, CARD_HEIGHT) + screen.centerPosition()[1];
    let coordX              = (adjustedPixelScaleX - gridOffsetX) / CardCoordinate.coordSize();
    let coordY              = (adjustedPixelScaleY - gridOffsetY) / CardCoordinate.coordSize();

    return new CardCoordinate(Math.min(Math.max(coordX, -100, 100), Math.min(Math.max(coordY, -100, 100));
  }

  get pxString() {
    return this.xPixels + 'px,' + this.yPixels + 'px';
  }

  get xPixels() {
    let relativePos  = this.x * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[0];
    let gridOffset   = CardCoordinate.cardGridOffset(this.x, CARD_WIDTH);
    return (screenCenter + relativePos + gridOffset) / this.cardScale;
  }

  get yPixels() {
    let relativePos  = this.y * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[1];
    let gridOffset   = CardCoordinate.cardGridOffset(this.y, CARD_HEIGHT);
    return (screenCenter + relativePos + gridOffset) / this.cardScale;
  }

  get cardScale() {
    return CardCoordinate.cardScale();
  }

  add(other) {
    return new CardCoordinate(this.x + other.x, this.y + other.y);
  }

  subtract(other) {
    return new CardCoordinate(this.x - other.x, this.y - other.y);
  }
}
