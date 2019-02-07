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
    // Basic untreated conversion
    let coordX = ((xPixels - screen.centerPosition()[0]) / CardCoordinate.coordSize());
    let coordY = ((yPixels - screen.centerPosition()[1]) / CardCoordinate.coordSize());

    // Calculate the offsets used to make the card fit in the grid in any direction
    const gridEndOffsetX = CARD_WIDTH * ((coordX + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();
    const gridEndOffsetY = CARD_HEIGHT * ((coordY + (GRID_SIZE / 2)) / GRID_SIZE) * CardCoordinate.cardScale();

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
    const relativePos  = this.x * CardCoordinate.coordSize();
    const screenCenter = screen.centerPosition()[0];
    const gridOffset   = CardCoordinate.cardGridOffset(this.x, CARD_WIDTH);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  get yPixels() {
    const relativePos  = this.y * CardCoordinate.coordSize();
    const screenCenter = screen.centerPosition()[1];
    const gridOffset   = CardCoordinate.cardGridOffset(this.y, CARD_HEIGHT);
    return (screenCenter + relativePos + gridOffset) / this.scale;
  }

  // Calculates whether a card in this position is overlapping a card in other position. Takes the size of the
  // cards into consideration.
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
