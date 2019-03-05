<template>
  <div>
    <form-input
      id="user_name"
      ref="username"
      name="user[name]"
      autocomplete="new-password"
      validation-url="/player_name_validators"
      :label="t('users.new.label_username')"
      :placeholder="t('activerecord.attributes.user.name')"
      @input="onNameChange"
    />

    <form-input
      id="user_email"
      ref="email"
      type="email"
      name="user[email]"
      autocomplete="new-password"
      :label="t('users.new.label_email')"
      :placeholder="t('activerecord.attributes.user.email')"
      @input="onEmailChange"
    />

    <form-input
      id="user_password"
      ref="password"
      type="password"
      name="user[password]"
      autocomplete="new-password"
      :label="t('users.new.label_password')"
      :placeholder="t('activerecord.attributes.user.password')"
      @input="onPasswordChange"
    />

    <button
      type="submit"
      class="btn btn-lg signup-btn"
      :disabled="!canSubmit"
    >
      {{ t('users.new.submit') }}
    </button>
  </div>
</template>

<script>
  import I18n from 'vendor/i18n-js.js.erb';

  export default {
    props: {},

    data() {
      return {
        usernameValid: false,
        emailValid:    false,
        passwordValid: false
      };
    },

    computed: {
      canSubmit() {
        return this.usernameValid && this.emailValid && this.passwordValid;
      }
    },

    methods: {
      t(name) {
        return I18n.t(name);
      },

      onNameChange(name, state) {
        this.usernameValid = state === 'valid';
      },

      onEmailChange(name, state) {
        this.emailValid = state === 'valid';
      },

      onPasswordChange(password) {
        this.passwordValid = password.length >= 6;
        const error = this.passwordValid ? null : I18n.t('users.new.password_error');
        this.$refs.password.setError(error);
      }
    }
  };
</script>
