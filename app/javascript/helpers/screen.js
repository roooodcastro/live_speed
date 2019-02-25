export default {
  clientWidth() {
    return document.documentElement.clientWidth;
  },

  clientHeight() {
    return document.documentElement.clientHeight;
  },

  // Returns the size, in pixels, of the smaller screen measure, either horizontal or vertical.
  smallerScreenSize() {
    return Math.min(this.clientWidth(), this.clientHeight());
  },

  // Returns the vmin size (smaller viewport unit) in pixels.
  vminSize() {
    return this.smallerScreenSize() / 100;
  },

  pxToVmin(pixels) {
    return pixels / this.vminSize();
  },

  // Returns an array with the x and y values of the center of the screen, in pixels.
  centerPosition() {
    return [this.clientWidth() / 2, this.clientHeight() / 2];
  }
};
