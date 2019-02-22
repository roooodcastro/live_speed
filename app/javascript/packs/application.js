/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

'use strict';

import '../stylesheets/application';

// Implemented own version of VueTurbolinks because of flickering issues
// https://github.com/jeffreyguenther/vue-turbolinks/issues/25
import TurbolinksAdapter from 'helpers/rod_vue_turbolinks';
import Vue               from 'vue/dist/vue.esm';

Vue.use(TurbolinksAdapter);

import PlayerNameInput from 'components/application/players/PlayerNameInput';
import NewPlayerForm from 'components/application/players/NewPlayerForm';
import MenuBar from 'components/application/layout/MenuBar';
import MenuBarLink from 'components/application/layout/MenuBarLink';

Vue.component('player-name-input', PlayerNameInput);
Vue.component('new-player-form', NewPlayerForm);
Vue.component('menu-bar', MenuBar);
Vue.component('menu-bar-link', MenuBarLink);

document.addEventListener('turbolinks:load', function () {
  window.vueApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: {},
    data:       {}
  });
});
