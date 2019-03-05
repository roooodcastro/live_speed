<template>
  <div class="form-input">
    <label
      v-if="createLabel"
      :for="id"
    >
      {{ label }}
    </label>
    <input
      :id="id"
      :name="name"
      :type="type"
      :value="value"
      :aria-label="computedAriaLabel"
      :placeholder="placeholder"
      :class="{ error: hasError }"
      :autocomplete="autocomplete"
      @input="onInput"
    >

    <span
      class="form-input-error"
    >
      {{ errorMessage }}
    </span>
  </div>
</template>

<script>
  import I18n          from 'vendor/i18n-js.js.erb';
  import axios         from 'axios';
  import { debounced } from 'helpers/forms';

  const api = axios.create({
    baseURL: '/'
  });

  export default {
    props: {
      type:                { type: String, default: 'text' },
      name:                { type: String, required: true },
      id:                  { type: String, default: null },
      initialValue:        { type: String, default: null },
      label:               { type: String, default: null },
      ariaLabel:           { type: String, default: null },
      autocomplete:        { type: String, default: null },
      placeholder:         { type: String, default: null },
      validationUrl:       { type: String, default: null },
      validationParamName: { type: String, default: 'value' }
    },

    data() {
      return {
        error: '',
        value: this.initialValue,
        state: ''
      };
    },

    computed: {
      computedAriaLabel() {
        return this.ariaLabel || this.label;
      },

      createLabel() {
        return !!this.id && !!this.label;
      },

      errorMessage() {
        if (!this.error) return '';

        return '✗ ' + this.error;
      },

      hasError() {
        return !!this.error;
      }
    },

    created() {
      this.debouncedValidation = debounced(500, this.validateValue);
    },

    methods: {
      setError(error) {
        if (error && this.value.length > 0) {
          this.state = 'error';
        } else if (this.value.length > 0) {
          this.state = 'valid';
        } else {
          this.state = '';
        }

        this.error = error;
      },

      onInput(ev) {
        this.value = ev.target.value;
        if (this.validationUrl) {
          this.state = 'validating';
          this.debouncedValidation();
        }
        this.$emit('input', this.value, this.state);
      },

      validateValue() {
        const params                     = {};
        params[this.validationParamName] = this.value;
        api
          .post(this.validationUrl, params)
          .catch(() => Promise.reject([I18n.t('generic_error')]))
          .then(({ data }) => {
            if (this.value.length > 0) {
              this.state = data.valid ? 'valid' : 'error';
              this.error = data.error;
            } else {
              this.state = '';
            }
            this.$emit('input', this.value, this.state);
          });
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';
  @import 'stylesheets/forms.scss';

  .form-input {
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
      font-size:     1rem;
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

      &.error {
        border-color: $red;

        &:focus {
          box-shadow: 0 0 0.5rem $red;
        }
      }
    }
  }

  .form-input-error {
    color:       $red;
    display:     block;
    font-size:   0.8rem;
    line-height: 2rem;
    text-align:  left;
  }
</style>
