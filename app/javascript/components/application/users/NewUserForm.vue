<template>
  <div>
    <rails-form-input
      ref="username"
      model="user"
      column="name"
      autocomplete="new-password"
      :label="t('users.new.label_username')"
      :placeholder="t('activerecord.attributes.user.name')"
      @input="onNameChange"
    />

    <rails-form-input
      ref="email"
      model="user"
      column="email"
      type="email"
      autocomplete="new-password"
      :label="t('users.new.label_email')"
      :placeholder="t('activerecord.attributes.user.email')"
      @input="onEmailChange"
    />

    <rails-form-input
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
      class="btn btn-lg signup-btn"
      :disabled="!canSubmit"
    >
      {{ 'users.new.submit' | i18n }}
    </button>
  </div>
</template>

<script>
  export default {
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
