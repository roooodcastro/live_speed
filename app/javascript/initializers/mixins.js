import Vue  from 'vue/dist/vue.esm';
import I18n from 'vendor/i18n-js-app.js.erb';

Vue.mixin({
  methods: {
    t(name, interpolations) {
      return I18n.t(name, interpolations);
    },
  },
});
