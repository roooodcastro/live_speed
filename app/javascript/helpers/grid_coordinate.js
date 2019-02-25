import screen        from 'helpers/screen';
import { GRID_SIZE } from 'helpers/constants';

export default class GridCoordinate {
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

  // Transforms a pixel position array (in the format [x, y]) into a CardCoordinate.
  static fromPixelPosition(xPixels, yPixels) {
    // Basic untreated conversion
    const coordX = ((xPixels - screen.centerPosition()[0]) / GridCoordinate.coordSize());
    const coordY = ((yPixels - screen.centerPosition()[1]) / GridCoordinate.coordSize());

    return new this.prototype.constructor(coordX, coordY);
  }

  get toString() {
    const xVmin = 50 + this.x / 2;
    const yVmin = 50 + this.y / 2;
    return 'calc(' + xVmin + 'vmin - 50%), calc(' + yVmin + 'vmin - 50%)';
  }

  add(other) {
    return new this.prototype.constructor(this.x + other.x, this.y + other.y);
  }
}
