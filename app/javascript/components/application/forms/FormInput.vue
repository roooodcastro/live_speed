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
  export default {
    props: {
      type:         { type: String, default: 'text' },
      name:         { type: String, required: true },
      id:           { type: String, default: null },
      initialValue: { type: String, default: null },
      label:        { type: String, default: null },
      ariaLabel:    { type: String, default: null },
      autocomplete: { type: String, default: null },
      placeholder:  { type: String, default: null }
    },

    data() {
      return {
        error: '',
        value: this.initialValue
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

    methods: {
      onInput(ev) {
        this.value = ev.target.value;
        this.$emit('input', ev);
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
