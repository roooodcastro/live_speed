<template>
  <form-input
    :id="inputId"
    ref="input"
    :name="inputName"
    :type="type"
    :initial-value="value"
    :label="inputLabel"
    :aria-label="ariaLabel"
    :autocomplete="autocomplete"
    :placeholder="placeholder"
    @input="onInput"
  />
</template>

<script>
  import pluralize     from 'pluralize';
  import I18n          from 'vendor/i18n-js-app.js.erb';
  import axios         from 'axios';
  import { debounced, } from 'helpers/forms';

  const api = axios.create({
    baseURL: '/',
  });

  export default {
    props: {
      type:         { type: String, default: 'text', },
      model:        { type: String, default: null, },
      column:       { type: String, required: true, },
      validate:     { type: Boolean, default: true, },
      showLabel:    { type: Boolean, default: false, },
      initialValue: { type: String, default: null, },
      label:        { type: String, default: null, },
      ariaLabel:    { type: String, default: null, },
      autocomplete: { type: String, default: null, },
      placeholder:  { type: String, default: null, },
    },

    data() {
      return {
        value: this.initialValue,
        error: '',
        state: '',
      };
    },

    computed: {
      inputName() {
        const columnSuffix = this.model ? '[' + this.column + ']' : this.column;
        return this.model + columnSuffix;
      },

      inputId() {
        return [this.model, this.column, ].filter(Boolean).join('_');
      },

      inputLabel() {
        if (this.label || !this.showLabel) return this.label;

        return this.humanizedColumnName();
      },

      humanizedColumnName() {
        if (this.column && this.model) return I18n.t('activerecord.attributes.' + this.model + '.' + this.column);

        return null;
      },

      validationUrl() {
        if (!this.model) return null;

        const pluralModel = pluralize(this.model);
        return '/' + pluralModel + '/validate';
      },
    },

    created() {
      this.debouncedValidation = debounced(500, this.validateValue);
    },

    methods: {
      onInput(value) {
        if (this.validationUrl && this.validate) {
          this.value = value;
          this.state = 'validating';
          this.$refs.input.setLoadingText(I18n.t('forms.validating', { attr: this.humanizedColumnName, }));
          this.debouncedValidation();
        }
        this.$emit('input', value, this.state);
      },

      validateValue() {
        const params = { column: this.column, value: this.value, };
        api
          .get(this.validationUrl, { params: params, })
          .catch(() => Promise.reject([I18n.t('generic_error'), ]))
          .then(({ data, }) => {
            if (this.value.length > 0) {
              this.state = data.valid ? 'valid' : 'error';
              this.$refs.input.setError(data.errors.join('<br />'));
            } else {
              this.state = '';
              this.$refs.input.setError(null);
            }
            this.$emit('input', this.value, this.state);
          })
          .finally(() => this.$refs.input.setLoadingText(''));
      },

      setError(error) {
        this.$refs.input.setError(error);
      },
    },
  };
</script>
