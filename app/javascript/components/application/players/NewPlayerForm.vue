<template>
  <div>
    <rails-form-input
      ref="username"
      model="player"
      column="own_name"
      autocomplete="new-password"
      :show-label="false"
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
  export default {
    props: {
      initialName: { type: String, default: '', },
    },

    data() {
      return {
        validName: false,
      };
    },

    computed: {
      btnDisabled() {
        return !this.validName;
      },
    },

    methods: {
      onNameChange(validName) {
        this.validName = validName;
      },
    },
  };
</script>
