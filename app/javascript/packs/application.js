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
import TurbolinksAdapter from 'vue-turbolinks';
import Vue               from 'vue/dist/vue.esm';

Vue.use(TurbolinksAdapter);

import PlayingCard  from '../components/PlayingCard';
import TheGameTable from '../components/TheGameTable';
import LoadingSuits from '../components/ui/LoadingSuits';
import Button       from '../components/ui/Button';
import Overlay      from '../components/ui/Overlay';
import Text         from '../components/ui/Text';

Vue.component('livespeed-playing-card', PlayingCard);
Vue.component('livespeed-gametable', TheGameTable);

// Common UI components
Vue.component('livespeed-button', Button);
Vue.component('livespeed-loading-suits', LoadingSuits);
Vue.component('livespeed-overlay', Overlay);
Vue.component('livespeed-text', Text);

document.addEventListener('turbolinks:load', () => {
  window.vueApp = new Vue({
    el:         '[data-behaviour="vue"]',
    data:       {},
    components: { TheGameTable }
  });
});
