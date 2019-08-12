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

import 'initializers/vue_config';
import 'initializers/mixins';
import 'initializers/filters';

import Vue from 'vue/dist/vue.esm';

// Layout
import MenuBar         from 'components/application/layout/MenuBar';
import MenuBarLink     from 'components/application/layout/MenuBarLink';
import AlertsContainer from 'components/application/layout/AlertsContainer';

// Forms
import FormInput      from 'components/application/forms/FormInput';
import RailsFormInput from 'components/application/forms/RailsFormInput';

// Resources
import NewPlayerForm from 'components/application/players/NewPlayerForm';
import NewUserForm   from 'components/application/users/NewUserForm';
import MatchList     from 'components/application/lobby/MatchList';

Vue.component('menu-bar', MenuBar);
Vue.component('menu-bar-link', MenuBarLink);
Vue.component('AlertsContainer', AlertsContainer);

Vue.component('form-input', FormInput);
Vue.component('rails-form-input', RailsFormInput);

Vue.component('new-player-form', NewPlayerForm);
Vue.component('new-user-form', NewUserForm);
Vue.component('MatchList', MatchList);

document.addEventListener('turbolinks:load', function () {
  window.vueApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: {},
    data:       {},
  });
});
