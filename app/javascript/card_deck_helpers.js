import {CARD_VERTICAL_SEPARATION} from './constants';

export function cardYOffset(cardIndex) {
  return cardIndex * CARD_VERTICAL_SEPARATION;
}
