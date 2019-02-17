<template>
  <div>
    <PlayerNameInput
      :initial-name="initialName"
      @validatedName="onNameChange"
    />

    <button
      type="submit"
      class="btn signup-btn"
      :disabled="btnDisabled"
    >
      Confirm
    </button>
  </div>
</template>

<script>
  import PlayerNameInput from 'components/players/PlayerNameInput';

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
      onNameChange(validName) {
        this.validName = validName;
      }
    }
  };
</script>
