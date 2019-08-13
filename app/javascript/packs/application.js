'use strict';

require.context('../images', true);
require('@rails/ujs').start();
require('helpers/string');

import '../stylesheets/application';

import 'initializers/vue_config';
import 'initializers/mixins';
import 'initializers/filters';
import 'initializers/vue_wrapper';

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

Vue.component('TheMenuBar', TheMenuBar);
Vue.component('MenuBarLink', MenuBarLink);
Vue.component('AlertsContainer', AlertsContainer);

Vue.component('NewPlayerForm', NewPlayerForm);
Vue.component('NewUserForm', NewUserForm);
Vue.component('MatchList', MatchList);
