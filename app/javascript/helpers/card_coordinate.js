import screen                                                           from './screen';
import { GRID_SIZE, CARD_WIDTH, CARD_HEIGHT, CARD_VERTICAL_SEPARATION } from '../constants';

export default class CardCoordinate {
  constructor(posX, posY, cardScale) {
    if (posX.constructor === Array) {
      this.x = posX[0];
      this.y = posX[1];
      this.scale = posY || CardCoordinate.cardScale();
    } else {
      this.x = posX;
      this.y = posY;
      this.scale = cardScale || CardCoordinate.cardScale();
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
      let targetWidth = (100 * CardCoordinate.coordSize()) / 4;
      return targetWidth / smallerSize;
    }
  }

  static cardCenterOffset(cardSize) {
    return (((cardSize * CardCoordinate.cardScale()) - cardSize) / 2);
  }

  static cardGridOffset(cardPos, cardSize) {
    let gridEndOffset = cardSize * ((cardPos + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();
    return CardCoordinate.cardCenterOffset(cardSize) - gridEndOffset;
  }

  // Transforms a pixel position array (in the format [x, y]) into a CardCoordinate.
  static fromPixelPosition(xPixels, yPixels) {
    // Basic untreated conversion
    let coordX = ((xPixels - screen.centerPosition()[0]) / CardCoordinate.coordSize());
    let coordY = ((yPixels - screen.centerPosition()[1]) / CardCoordinate.coordSize());

    // Calculate the offsets used to make the card fit in the grid in any direction
    let gridEndOffsetX = CARD_WIDTH * ((coordX + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();
    let gridEndOffsetY = CARD_HEIGHT * ((coordY + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();

    // Add calculated offset plus the half-sized card offset, converted from pixels to coords
    coordX += (gridEndOffsetX + CardCoordinate.cardCenterOffset(CARD_WIDTH) / 2) / CardCoordinate.coordSize();
    coordY += (gridEndOffsetY + CardCoordinate.cardCenterOffset(CARD_HEIGHT) / 2) / CardCoordinate.coordSize();

    return new CardCoordinate(coordX, coordY);
  }

  static cardYOffset(cardIndex) {
    return cardIndex * CARD_VERTICAL_SEPARATION;
  }


  get pxString() {
    return this.xPixels + 'px,' + this.yPixels + 'px';
  }

  get xPixels() {
    let relativePos  = this.x * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[0];
    let gridOffset   = CardCoordinate.cardGridOffset(this.x, CARD_WIDTH);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  get yPixels() {
    let relativePos  = this.y * CardCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[1];
    let gridOffset   = CardCoordinate.cardGridOffset(this.y, CARD_HEIGHT);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  // Calculates whether a card in this position is overlapping a card in other position. Takes the size of the
  // cards into consideration.
  isOverlapping(other) {
    let trueCardWidth  = (CARD_WIDTH * this.scale) / CardCoordinate.coordSize();
    let trueCardHeight = (CARD_HEIGHT * this.scale) / CardCoordinate.coordSize();
    let overlappingX   = other.x > (this.x - trueCardWidth) && other.x < (this.x + trueCardWidth);
    let overlappingY   = other.y > (this.y - trueCardHeight) && other.y < (this.y + trueCardHeight);

    return overlappingX && overlappingY;
  }

  add(other) {
    return new CardCoordinate(this.x + other.x, this.y + other.y);
  }
}
