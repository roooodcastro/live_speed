'use strict';

require('@rails/ujs').start();
require('helpers/string');

import '../stylesheets/game';

import 'initializers/vue_config';
import 'initializers/mixins';
import 'initializers/filters';
import 'initializers/vue_wrapper';

import Vue from 'vue/dist/vue.esm';

// ===== Components =====

import TheGameTable from 'components/game/TheGameTable';

Vue.component('thegametable', TheGameTable);
