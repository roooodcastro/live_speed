// Implemented own version of VueTurbolinks because of flickering issues
// https://github.com/jeffreyguenther/vue-turbolinks/issues/25
import Turbolinks        from 'turbolinks';
import TurbolinksAdapter from 'helpers/rod_vue_turbolinks';
import Vue               from 'vue/dist/vue.esm';

Turbolinks.start();
Vue.use(TurbolinksAdapter);
