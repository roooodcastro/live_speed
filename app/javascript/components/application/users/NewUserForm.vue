<template>
  <div>
    <RailsFormInput
      ref="username"
      model="user"
      column="name"
      autocomplete="new-password"
      :label="t('users.new.label_username')"
      :placeholder="t('activerecord.attributes.user.name')"
      @input="onNameChange"
    />

    <RailsFormInput
      ref="email"
      model="user"
      column="email"
      type="email"
      autocomplete="new-password"
      :label="t('users.new.label_email')"
      :placeholder="t('activerecord.attributes.user.email')"
      @input="onEmailChange"
    />

    <RailsFormInput
      ref="password"
      model="user"
      column="password"
      type="password"
      autocomplete="new-password"
      :validate="false"
      :label="t('users.new.label_password')"
      :placeholder="t('activerecord.attributes.user.password')"
      @input="onPasswordChange"
    />

    <button
      type="submit"
      class="btn btn-lg btn-signup"
      :disabled="!canSubmit"
    >
      {{ 'users.new.submit' | i18n }}
    </button>

    <LinkButton
      :href="r('new_player_path')"
      :label="'users.new.new_player_btn' | i18n"
      variant="btn-lg btn-outline btn-signup btn-mobile"
    />

    <LinkButton
      :href="r('login_path')"
      :label="'users.new.login_btn' | i18n"
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

    props: {},

    data() {
      return {
        usernameValid: false,
        emailValid:    false,
        passwordValid: false,
      };
    },

    computed: {
      canSubmit() {
        return this.usernameValid && this.emailValid && this.passwordValid;
      },
    },

    methods: {
      onNameChange(name, state) {
        this.usernameValid = state === 'valid';
      },

      onEmailChange(name, state) {
        this.emailValid = state === 'valid';
      },

      onPasswordChange(password) {
        this.passwordValid = password.length >= 6;
        const error = this.passwordValid ? null : this.t('users.new.password_error');
        this.$refs.password.setError(error);
      },
    },
  };
</script>
