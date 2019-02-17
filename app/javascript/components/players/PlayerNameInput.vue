<template>
  <div class="player-name-input">
    <input
      id="player_name"
      type="text"
      :value="name"
      aria-label="Type your player name"
      placeholder="Player Name"
      @input="onNameInput"
    >

    <span
      v-show="state === ''"
      class="player-name-input-result"
    >&nbsp;
    </span>

    <span
      v-show="state === 'validating'"
      class="player-name-input-result validating"
    >
      Checking name…
    </span>

    <span
      v-show="state === 'valid'"
      class="player-name-input-result valid"
    >
      ✓ This name is valid!
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

    created() {
      this.debouncedValidateName = debounced(500, this.validateName);
    },

    methods: {
      onNameInput(ev) {
        this.state = 'validating';
        this.name  = ev.target.value;
        this.debouncedValidateName();
      },

      validateName() {
        api
          .post('/', { name: this.name })
          .catch(() => Promise.reject(['Unexpected error. Please contact an administrator.']))
          .then(({ data }) => {
            if (this.name.length > 0) {
              this.state = data.valid ? 'valid' : 'error';
              this.error = data.error;
            } else {
              this.state = '';
            }
          });
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/forms.scss';
  @import 'stylesheets/_variables.scss';

  .player-name-input {
    font-family: 'Open Sans', Arial, sans-serif;

    label {
      display:     inline-block;
      line-height: 2rem;
      text-align:  left;
      width:       100%;
    }

    input {
      border:        1px solid $brand-gray-7;
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
