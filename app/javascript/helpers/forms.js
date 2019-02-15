export function debounced(delay, fn) {
  let timerId = null;
  return function (...args) {
    if (timerId) {
      clearTimeout(timerId);
    }
    timerId = setTimeout(function () {
      fn(...args);
      timerId = null;
    }, delay);
  }
}
