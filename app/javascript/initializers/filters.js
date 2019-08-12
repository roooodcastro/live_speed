import Vue  from 'vue/dist/vue.esm';
import I18n from 'vendor/i18n-js-app.js.erb';

Vue.filter('i18n', I18n.translate);
