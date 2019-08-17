import Vue  from 'vue/dist/vue.esm';
import I18n from 'vendor/i18n-js-app.js.erb';
import Routes from 'initializers/js_routes.js.erb';

Vue.mixin({
  methods: {
    t(name, interpolations) {
      return I18n.t(name, interpolations);
    },
    r(name, params) {
      return Routes[name](params);
    },
  },
});
