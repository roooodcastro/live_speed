/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

'use strict';

require.context('../images', true);
require('@rails/ujs').start();
require('helpers/string');

import '../stylesheets/application';

// Implemented own version of VueTurbolinks because of flickering issues
// https://github.com/jeffreyguenther/vue-turbolinks/issues/25
import Turbolinks        from 'turbolinks';
import TurbolinksAdapter from 'helpers/rod_vue_turbolinks';
import Vue               from 'vue/dist/vue.esm';

Turbolinks.start();
Vue.use(TurbolinksAdapter);

import NewPlayerForm   from 'components/application/players/NewPlayerForm';
import NewUserForm     from 'components/application/users/NewUserForm';
import Button          from 'components/application/layout/Button';
import MenuBar         from 'components/application/layout/MenuBar';
import MenuBarLink     from 'components/application/layout/MenuBarLink';
import AlertsContainer from 'components/application/layout/AlertsContainer';
import FormInput       from 'components/application/forms/FormInput';
import RailsFormInput  from 'components/application/forms/RailsFormInput';
import MatchList       from 'components/application/lobby/MatchList';

Vue.component('new-player-form', NewPlayerForm);
Vue.component('new-user-form', NewUserForm);
Vue.component('vue-button', Button);
Vue.component('menu-bar', MenuBar);
Vue.component('menu-bar-link', MenuBarLink);
Vue.component('alerts-container', AlertsContainer);
Vue.component('form-input', FormInput);
Vue.component('rails-form-input', RailsFormInput);
Vue.component('match-list', MatchList);

document.addEventListener('turbolinks:load', function () {
  window.vueApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: {},
    data:       {},
  });
});
