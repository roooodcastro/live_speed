'use strict';

require.context('../images', true);
require('@rails/ujs').start();
require('helpers/string');

import '../stylesheets/application';

import 'initializers/vue_config';
import 'initializers/mixins';
import 'initializers/filters';
import 'initializers/vue_wrapper';
import Routes from 'initializers/js_routes.js.erb';

window.Routes = Routes;

import Vue from 'vue/dist/vue.esm';

// ===== Components =====

// Layout
import TheMenuBar      from 'components/application/layout/TheMenuBar';
import MenuBarLink     from 'components/application/layout/MenuBarLink';
import AlertsContainer from 'components/application/layout/AlertsContainer';

// Resources
import NewPlayerForm from 'components/application/players/NewPlayerForm';
import NewUserForm   from 'components/application/users/NewUserForm';
import MatchList     from 'components/application/lobby/MatchList';

Vue.component('themenubar', TheMenuBar);
Vue.component('menubarlink', MenuBarLink);
Vue.component('alertscontainer', AlertsContainer);

Vue.component('newplayerform', NewPlayerForm);
Vue.component('newuserform', NewUserForm);
Vue.component('matchlist', MatchList);
