<template>
  <div>
    <form-input
      id="user_name"
      ref="username"
      name="user[name]"
      autocomplete="new-password"
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
    >
      {{ t('users.new.submit') }}
    </button>
  </div>
</template>

<script>
  import I18n          from 'vendor/i18n-js.js.erb';
  import axios         from 'axios';
  import { debounced } from 'helpers/forms';

  const api = axios.create({
    baseURL: '/player_name_validators'
  });

  export default {
    props: {},

    data() {
      return {
        usernameValid: false,
        emailValid:    false,
        passwordValid: false
      };
    },

    computed: {},

    created() {
      this.debouncedValidateName  = debounced(500, this.validateName);
      this.debouncedValidateEmail = debounced(500, this.validateEmail);
    },

    methods: {
      t(name) {
        return I18n.t(name);
      },

      onNameChange(ev) {
        this.debouncedValidateName(ev);
      },

      onEmailChange(ev) {
        this.debouncedValidateEmail(ev);
      },

      onPasswordChange(ev) {
        this.passwordValid = ev.target.value.length >= 6;
        if (!this.passwordValid) {
          this.$refs.password.error = I18n.t('users.new.password_error');
        } else {
          this.$refs.password.error = null;
        }
      },

      validateName(ev) {
        api
          .post('/', { name: ev.target.value })
          .catch(() => Promise.reject([I18n.t('generic_error')]))
          .then(({ data }) => {
            if (ev.target.value.length > 0) {
              this.usernameValid = data.valid;
              this.$refs.username.error = data.error;
            } else {
              this.$refs.username.error = '';
            }
            this.$emit('validatedName', this.state === 'valid');
          });
      },

      validateEmail() {
      }
    }
  };
</script>
