import screen         from 'helpers/screen';
import {
  CARD_WIDTH,
  CARD_HEIGHT,
  CARD_VERTICAL_SEPARATION,
}                     from 'helpers/constants';
import GridCoordinate from 'helpers/grid_coordinate';

export default class CardCoordinate extends GridCoordinate {
  static cardScale() {
    const clientW = screen.clientWidth();
    const clientH = screen.clientHeight();
    if (clientW > clientH) {
      const smallerSize  = CARD_WIDTH;
      const targetHeight = (100 * CardCoordinate.coordSize()) / 4;
      return targetHeight / smallerSize;
    } else {
      const smallerSize = CARD_HEIGHT;
      const targetWidth = (100 * CardCoordinate.coordSize()) / 2.5;
      return targetWidth / smallerSize;
    }
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

  // Calculates whether a card in this position is overlapping a card in other position.
  // Takes the size of the cards into consideration.
  isOverlapping(other) {
    const trueCardWidth  = (CARD_WIDTH * CardCoordinate.cardScale()) / CardCoordinate.coordSize();
    const trueCardHeight = (CARD_HEIGHT * CardCoordinate.cardScale()) / CardCoordinate.coordSize();
    const overlappingX   = other.x > (this.x - trueCardWidth) && other.x < (this.x + trueCardWidth);
    const overlappingY   = other.y > (this.y - trueCardHeight) && other.y < (this.y + trueCardHeight);

    return overlappingX && overlappingY;
  }
}
