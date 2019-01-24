import { GRID_SIZE } from '../constants';

export default {
  clientWidth() {
    return document.documentElement.clientWidth;
  },

  clientHeight() {
    return document.documentElement.clientHeight;
  },

  aspectRatio() {
    return this.clientWidth() / this.clientHeight();
  },

  smallerScreenSize() {
    return Math.min(this.clientWidth(), this.clientHeight());
  },

  centerPosition() {
    return [this.clientWidth() / 2, this.clientHeight() / 2];
  },

  coordinatesToScreenPosition(coordX, coordY) {
    let coordSize = this.smallerScreenSize() / GRID_SIZE;
    let offsetX = coordX * coordSize;
    let offsetY = coordY * coordSize;
    return [this.centerPosition()[0] + offsetX, this.centerPosition()[1] + offsetY];
  },

  scaleOffset(size, scale) {
    return (size - (size * scale)) / 2;
  }
};
