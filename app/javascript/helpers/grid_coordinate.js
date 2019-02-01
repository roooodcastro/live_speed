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
    let coordX = ((xPixels - screen.centerPosition()[0]) / GridCoordinate.coordSize());
    let coordY = ((yPixels - screen.centerPosition()[1]) / GridCoordinate.coordSize());

    return new GridCoordinate(coordX, coordY);
  }

  get pxString() {
    return 'calc(' + this.xPixels + 'px - 50%),' + 'calc(' + this.yPixels + 'px - 50%)';
  }

  get xPixels() {
    let relativePos  = this.x * GridCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[0];
    return screenCenter + relativePos;
  }

  get yPixels() {
    let relativePos  = this.y * GridCoordinate.coordSize();
    let screenCenter = screen.centerPosition()[1];
    return screenCenter + relativePos;
  }

  add(other) {
    return new GridCoordinate(this.x + other.x, this.y + other.y);
  }
}
