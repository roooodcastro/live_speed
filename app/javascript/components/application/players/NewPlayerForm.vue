<template>
  <div>
    <RailsFormInput
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
      class="btn btn-lg btn-signup"
      :disabled="btnDisabled"
    >
      {{ 'players.new.submit' | i18n }}
    </button>

    <LinkButton
      :href="r('new_user_path')"
      :label="'players.new.signup_btn' | i18n"
      variant="btn-lg btn-outline btn-signup btn-mobile"
    />

    <LinkButton
      :href="r('new_sessions_path')"
      :label="'players.new.login_btn' | i18n"
      variant="btn-lg btn-outline btn-signup btn-mobile"
    />
  </div>
</template>

<script>
  import RailsFormInput from 'components/application/forms/RailsFormInput';
  import LinkButton from 'components/application/layout/LinkButton';

  export default {
    components: {
      RailsFormInput,
      LinkButton,
    },

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
