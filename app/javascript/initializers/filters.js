import Vue  from 'vue/dist/vue.esm';
import I18n from 'vendor/i18n-js-app.js.erb';

Vue.filter('i18n', (scope, options) => I18n.translate(scope, Object.assign({ defaultValue: scope, }, options)));
