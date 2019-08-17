<template>
  <ModalOverlay
    ref="overlay"
    title="forms.new_match_form.title"
  >
    <RailsForm :action="r('matches_path')">
      <FormSelect
        id="match_num_players"
        name="match[num_players]"
        selected="2"
        label="activerecord.attributes.match.num_players"
        :options="numPlayersOptions"
      />

      <FormSelect
        id="match_num_rounds"
        name="match[num_rounds]"
        selected="5"
        label="activerecord.attributes.match.num_rounds"
        :options="numRoundsOptions"
      />

      <button
        type="submit"
        class="btn btn-lg NewMatchForm__submit-button"
      >
        {{ 'forms.new_match_form.submit' | i18n }}
      </button>
    </RailsForm>
  </ModalOverlay>
</template>

<script>
  import ModalOverlay from 'components/application/layout/ModalOverlay';
  import RailsForm    from 'components/application/forms/RailsForm';
  import FormSelect   from 'components/application/forms/FormSelect';

  export default {
    components: {
      ModalOverlay,
      RailsForm,
      FormSelect,
    },

    computed: {
      numRoundsOptions() {
        const descI18nKey = 'activerecord.attributes.match.num_rounds_description';
        return [
          ['3', this.t(descI18nKey, { rounds: 3, }), ],
          ['5', this.t(descI18nKey, { rounds: 5, }), ],
          ['7', this.t(descI18nKey, { rounds: 7, }), ],
        ];
      },

      numPlayersOptions() {
        return [['2', '2', ], ['4', '4', ], ];
      },
    },

    methods: {
      open() {
        this.$refs.overlay.open();
      },
    },
  };
</script>

<style lang="scss">
  .NewMatchForm__submit-button {
    margin-top: 1rem;
    width: 100%;
  }
</style>
