import Vue from 'vue/dist/vue.esm';

document.addEventListener('turbolinks:load', function () {
  window.vueApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: {},
    data:       {},
  });
});
