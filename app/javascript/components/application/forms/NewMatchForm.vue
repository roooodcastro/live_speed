<template>
  <ModalOverlay
    ref="overlay"
    title="forms.new_match_form.title"
  >
    <span>oi</span>
  </ModalOverlay>
</template>

<script>
  import ModalOverlay from 'components/application/layout/ModalOverlay';

  export default {
    components: {
      ModalOverlay,
    },

    methods: {
      open() {
        this.$refs.overlay.open();
      },
    },
  };
</script>

<style lang="scss">

</style>
