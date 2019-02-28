<template>
  <div class="player-name-input">
    <input
      id="player_own_name"
      name="player[own_name]"
      type="text"
      :value="name"
      :aria-label="t('players.new.name_aria_label')"
      :placeholder="t('players.new.name_placeholder')"
      @input="onNameInput"
    >

    <span
      v-show="state === ''"
      class="player-name-input-result"
    >
      &nbsp;
    </span>

    <span
      v-show="state === 'validating'"
      class="player-name-input-result validating"
    >
      {{ t('players.new.checking_name') }}
    </span>

    <span
      v-show="state === 'valid'"
      class="player-name-input-result valid"
    >
      {{ t('players.new.valid_name') }}
    </span>

    <span
      v-show="state === 'error'"
      class="player-name-input-result error"
    >
      ✗ {{ error }}
    </span>
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
    props: {
      initialName: { type: String, default: '' }
    },

    data() {
      return {
        name:  this.initialName,
        error: '',
        state: ''
      };
    },

    computed: {
      validName() {
        return this.state === 'valid';
      }
    },

    created() {
      this.debouncedValidateName = debounced(500, this.validateName);
    },

    methods: {
      t(name) {
        return I18n.t(name);
      },

      onNameInput(ev) {
        this.state = 'validating';
        this.$emit('validatedName', this.state === 'valid');
        this.name = ev.target.value;
        this.debouncedValidateName();
      },

      validateName() {
        api
          .post('/', { name: this.name })
          .catch(() => Promise.reject([I18n.t('players.new.error')]))
          .then(({ data }) => {
            if (this.name.length > 0) {
              this.state = data.valid ? 'valid' : 'error';
              this.error = data.error;
            } else {
              this.state = '';
            }
            this.$emit('validatedName', this.state === 'valid');
          });
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';
  @import 'stylesheets/forms.scss';

  .player-name-input {
    font-family: 'Open Sans', Arial, sans-serif;

    label {
      display:     inline-block;
      line-height: 2rem;
      text-align:  left;
      width:       100%;
    }

    input {
      border:        1px solid $input-border-color;
      border-radius: 4px;
      color:         $brand-black;
      font-size:     1.2rem;
      line-height:   2.4rem;
      outline:       none;
      padding:       0 1rem;
      width:         100%;

      &::placeholder {
        color: $brand-gray-5;
      }

      &:focus {
        box-shadow: 0 0 0.5rem $brand-1;
      }
    }
  }

  .player-name-input-result {
    display:      block;
    line-height:  2rem;
    padding-left: 1rem;
    text-align:   left;

    &.valid { color: $brand; }

    &.error { color: $brand-alt; }

    &.validating { color: $brand-gray-4; }
  }
</style>
