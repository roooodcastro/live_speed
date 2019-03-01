<template>
  <div>
    <PlayerNameInput
      :initial-name="initialName"
      @validatedName="onNameChange"
    />

    <button
      type="submit"
      class="btn btn-lg signup-btn"
      :disabled="btnDisabled"
    >
      {{ t('players.new.submit') }}
    </button>
  </div>
</template>

<script>
  import I18n            from 'vendor/i18n-js.js.erb';
  import PlayerNameInput from 'components/application/players/PlayerNameInput';

  export default {
    components: { PlayerNameInput },

    props: {
      initialName: { type: String, default: '' }
    },

    data() {
      return {
        validName: false
      };
    },

    computed: {
      btnDisabled() {
        return !this.validName;
      }
    },

    methods: {
      t(name) {
        return I18n.t(name);
      },

      onNameChange(validName) {
        this.validName = validName;
      }
    }
  };
</script>
