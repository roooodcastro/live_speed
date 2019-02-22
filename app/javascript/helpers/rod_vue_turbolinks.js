function handleVueDestructionOn(turbolinksEvent, vue) {
  document.addEventListener(turbolinksEvent, function teardown() {
    vue.$destroy();
    document.removeEventListener(turbolinksEvent, teardown);
  });
}

function isTurbolinksCacheDisabled() {
  const meta = document.head.querySelector('[name="turbolinks-cache-control"]');

  return meta && meta.content === 'no-cache';
}

function plugin(Vue) {
  // Install a global mixin
  Vue.mixin({
    beforeMount: function () {
      // If this is the root component, we want to cache the original element contents to replace later
      // We don't care about sub-components, just the root
      if (this === this.$root && this.$el) {
        const defaultDestroyEvent = isTurbolinksCacheDisabled()
          ? 'turbolinks:visit'
          : 'turbolinks:before-cache';
        const destroyEvent = this.$options.turbolinksDestroyEvent || defaultDestroyEvent;
        handleVueDestructionOn(destroyEvent, this);
        this.$originalEl = this.$el.outerHTML;
      }
    },

    destroyed: function () {
      // We only need to revert the html for the root component
      if (this === this.$root && this.$el) {
        this.$el.outerHTML = this.$originalEl;
      }
    }
  })
}

export default plugin;
