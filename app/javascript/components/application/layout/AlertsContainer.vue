<template>
  <div
    class="AlertsContainer"
    :class="{ 'AlertsContainer--float': float }"
  >
    <RailsAlert
      v-for="(alert, index) in displayedAlerts"
      :key="'alert-' + index"
      :title="alert.title"
      :content="alert.content"
      :type="alert.type"
      @close="removeAlert(index)"
    />
  </div>
</template>

<script>
  import RailsAlert from 'components/application/layout/RailsAlert';

  export default {
    components: {
      RailsAlert,
    },

    props: {
      alerts: { type: Array, required: true, },
      float: { type: Boolean, default: false, },
    },

    data() {
      return {
        displayedAlerts: this.alerts,
      };
    },

    methods: {
      removeAlert(index) {
        this.displayedAlerts.splice(index, 1);
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_grid.scss';

  .AlertsContainer {
    @extend %grid;

    align-items: center;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    padding: 0;
  }

  .AlertsContainer--float {
    position: absolute;
    left: 50%;
    margin-top: 4rem;
    transform: translate(-50%, 0);
    z-index: 100;
  }
</style>
