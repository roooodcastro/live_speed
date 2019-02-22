/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

'use strict';

import '../stylesheets/game';
import TurbolinksAdapter from 'vue-turbolinks';
import Vue               from 'vue/dist/vue.esm';

Vue.use(TurbolinksAdapter);

import PlayingCard  from 'components/game/PlayingCard';
import TheGameTable from 'components/game/TheGameTable';

import Arrow           from 'components/game/ui/Arrow';
import Button          from 'components/game/ui/Button';
import LoadingEllipsis from 'components/game/ui/LoadingEllipsis';
import LoadingSuits    from 'components/game/ui/LoadingSuits';
import Overlay         from 'components/game/ui/Overlay';
import Text            from 'components/game/ui/Text';

Vue.component('livespeed-playing-card', PlayingCard);
Vue.component('livespeed-gametable', TheGameTable);

// Common UI components
Vue.component('livespeed-arrow', Arrow);
Vue.component('livespeed-button', Button);
Vue.component('livespeed-loading-ellipsis', LoadingEllipsis);
Vue.component('livespeed-loading-suits', LoadingSuits);
Vue.component('livespeed-overlay', Overlay);
Vue.component('livespeed-text', Text);

document.addEventListener('turbolinks:load', () => {
  window.gameApp = new Vue({
    el:         '[data-behaviour="vue"]',
    components: { TheGameTable },
    data:       {}
  });
});
