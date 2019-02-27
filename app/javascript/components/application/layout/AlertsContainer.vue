<template>
  <div
    class="alerts-container"
    :class="{ 'alerts-float': float }"
  >
    <Alert
      v-for="(alert, index) in alerts"
      :key="'alert-' + index"
      :title="alert.title"
      :content="alert.content"
      :type="alert.type"
    />
  </div>
</template>

<script>
  import Alert from 'components/application/layout/Alert';

  export default {
    components: { Alert },

    props: {
      alerts: { type: Array, required: true },
      float: { type: Boolean, default: false }
    }
  };
</script>

<style lang="scss">
  .alerts-container {
    align-items: center;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
  }

  .alerts-float {
    position: absolute;
    left: 50%;
    margin-top: 4rem;
    transform: translate(-50%, 0);
    z-index: 100;
  }
</style>
