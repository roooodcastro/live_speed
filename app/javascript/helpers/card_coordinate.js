import screen                                                           from 'helpers/screen';
import { GRID_SIZE, CARD_WIDTH, CARD_HEIGHT, CARD_VERTICAL_SEPARATION } from 'helpers/constants';

export default class CardCoordinate {
  constructor(posX, posY, cardScale) {
    if (posX.constructor === Array) {
      this.x     = posX[0];
      this.y     = posX[1];
      this.scale = posY || CardCoordinate.cardScale();
    } else {
      this.x     = posX;
      this.y     = posY;
      this.scale = cardScale || CardCoordinate.cardScale();
    }
  }

  static coordSize() {
    return screen.smallerScreenSize() / GRID_SIZE;
  }

  static cardScale() {
    const clientW = screen.clientWidth();
    const clientH = screen.clientHeight();
    if (clientW > clientH) {
      const smallerSize  = CARD_WIDTH;
      const targetHeight = (100 * CardCoordinate.coordSize()) / 5;
      return targetHeight / smallerSize;
    } else {
      const smallerSize = CARD_HEIGHT;
      const targetWidth = (100 * CardCoordinate.coordSize()) / 4;
      return targetWidth / smallerSize;
    }
  }

  static cardCenterOffset(cardSize) {
    return (((cardSize * CardCoordinate.cardScale()) - cardSize) / 2);
  }

  static cardGridOffset(cardPos, cardSize) {
    const gridEndOffset = cardSize * ((cardPos + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();
    return CardCoordinate.cardCenterOffset(cardSize) - gridEndOffset;
  }

  // Transforms a pixel position array (in the format [x, y]) into a CardCoordinate.
  static fromPixelPosition(xPixels, yPixels) {
    let coordX = (xPixels - screen.centerPosition()[0]) / screen.vminSize() * 2;
    let coordY = (yPixels - screen.centerPosition()[1]) / screen.vminSize() * 2;

    return new CardCoordinate(coordX, coordY);
  }

  // Returns the vertical offset of a specific card in a card stack. The greater the cardIndex, the greater the offset
  // will be. This is used to simulate a 3D representation of a card stack, giving a sense of depth.
  static cardYOffset(cardIndex) {
    return cardIndex * CARD_VERTICAL_SEPARATION;
  }

  static get scaledCardWidth() {
    return CARD_WIDTH * CardCoordinate.cardScale();
  }

  static get scaledCardHeight() {
    return CARD_HEIGHT * CardCoordinate.cardScale();
  }

  get toString() {
    return this.xVmin + 'vmin,' + this.yVmin + 'vmin';
  }

  get xVmin() {
    return 50 + (this.x / 2) - screen.pxToVmin(CardCoordinate.scaledCardWidth / 2);
  }

  get yVmin() {
    return 50 + (this.y / 2) - screen.pxToVmin(CardCoordinate.scaledCardHeight / 2);
  }

  // Calculates whether a card in this position is overlapping a card in other position.
  // Takes the size of the cards into consideration.
  isOverlapping(other) {
    const trueCardWidth  = (CARD_WIDTH * this.scale) / CardCoordinate.coordSize();
    const trueCardHeight = (CARD_HEIGHT * this.scale) / CardCoordinate.coordSize();
    const overlappingX   = other.x > (this.x - trueCardWidth) && other.x < (this.x + trueCardWidth);
    const overlappingY   = other.y > (this.y - trueCardHeight) && other.y < (this.y + trueCardHeight);

    return overlappingX && overlappingY;
  }

  add(other) {
    return new CardCoordinate(this.x + other.x, this.y + other.y);
  }
}
