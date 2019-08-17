<template>
  <ModalOverlay
    ref="overlay"
    title="forms.new_match_form.cpu_title"
  >
    <RailsForm :action="r('matches_path')">
      <input
        type="hidden"
        name="match[cpu_match]"
        value="true"
      >
      <input
        type="hidden"
        name="match[num_players]"
        value="2"
      >

      <select name="match[num_rounds]">
        <option
          value="3"
          selected="true"
        >
          3
        </option>
        <option value="5">
          5
        </option>
        <option value="7">
          7
        </option>
      </select>

      <button
        type="submit"
        class="btn"
      >
        {{ 'forms.new_match_form.submit' | i18n }}
      </button>
    </RailsForm>
  </ModalOverlay>
</template>

<script>
  import ModalOverlay from 'components/application/layout/ModalOverlay';
  import RailsForm    from 'components/application/forms/RailsForm';

  export default {
    components: {
      ModalOverlay,
      RailsForm,
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
