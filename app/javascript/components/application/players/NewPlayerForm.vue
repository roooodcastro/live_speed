<template>
  <div>
    <rails-form-input
      ref="username"
      model="player"
      column="own_name"
      autocomplete="new-password"
      label=""
      :aria-label="t('players.new.name_aria_label')"
      :placeholder="t('players.new.name_placeholder')"
      :initial-value="initialName"
      @input="onNameChange"
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
  import I18n from 'vendor/i18n-js.js.erb';

  export default {
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
