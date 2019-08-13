// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

'use strict';

require('@rails/ujs').start();
require('helpers/string');

import '../stylesheets/game';

import 'initializers/vue_config';
import 'initializers/mixins';
import 'initializers/filters';

import Vue from 'vue/dist/vue.esm';

import TheGameTable from 'components/game/TheGameTable';

Vue.component('livespeed-gametable', TheGameTable);

document.addEventListener('turbolinks:load', function () {
  window.gameApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: { TheGameTable, },
    data:       {},
  });
});
