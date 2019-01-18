/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import '../stylesheets/application'
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'

Vue.use(TurbolinksAdapter)

import PlayingCard from '../components/playing_card'
import GameTable from '../components/game_table'

Vue.component('livespeed-playing-card', PlayingCard);
Vue.component('livespeed-gametable', GameTable);

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '[data-behaviour="vue"]',
    data: {},
    components: {
      PlayingCard,
      GameTable
    }
  });

  window.vue = app;
});
