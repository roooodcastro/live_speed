<template>
  <div class="FormSelect">
    <label
      v-if="createLabel"
      :for="id"
    >
      {{ label | i18n }}
    </label>
    <select
      :id="id"
      :name="name"
      :aria-label="computedAriaLabel"
      :class="cssClass"
      @select="onSelect"
    >
      <option
        v-if="blankOption"
        :selected="!selected"
      >
        {{ blankOption | i18n }}
      </option>
      <option
        v-for="option in options"
        :key="option[0]"
        :value="option[0]"
        :selected="selected === option[0] ? 'selected' : null"
      >
        {{ option[1] | i18n }}
      </option>
    </select>

    <span class="FormSelect--error">
      {{ errorMessage }}
    </span>
  </div>
</template>

<script>
  export default {
    props: {
      name:        {
        type:     String,
        required: true,
      },
      id:          {
        type:    String,
        default: null,
      },
      selected:    {
        type:    String,
        default: null,
      },
      label:       {
        type:    String,
        default: null,
      },
      ariaLabel:   {
        type:    String,
        default: null,
      },
      blankOption: {
        type:    String,
        default: null,
      },
      options:     {
        type:     Array,
        required: true,
      },
    },

    data() {
      return {
        error:           '',
        currentSelected: this.selected,
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
      },

      hasValue() {
        return this.currentSelected && this.currentSelected.length > 0;
      },

      state() {
        if (this.hasError && this.hasValue) {
          return 'error';
        } else if (this.hasValue) {
          return 'valid';
        } else {
          return '';
        }
      },

      cssClass() {
        return {
          error: this.state === 'error',
          valid: this.state === 'valid',
        };
      },
    },

    methods: {
      setError(error) {
        this.error = error;
      },

      setLoadingText(text) {
        this.loadText = text;
      },

      onSelect(ev) {
        this.currentSelected = ev.target.selected;
        this.$emit('select', this.currentSelected);
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .FormSelect {
    font-family: 'Open Sans', Arial, sans-serif;

    label {
      display:     inline-block;
      line-height: 2rem;
      text-align:  left;
      width:       100%;
    }

    select {
      background-color: $brand-gray-9;
      border:           1px solid $input-border-color;
      border-radius:    4px;
      color:            $brand-black;
      font-size:        1rem;
      height:           2.4rem;
      outline:          none;
      padding:          0 1rem;
      width:            100%;

      option {

      }

      &::placeholder {
        color: $brand-gray-5;
      }

      &:focus {
        box-shadow: 0 0 0.5rem $brand-1;
      }

      &:hover {
        background-color: $brand-gray-9;
      }

      &.error {
        border-color: $red;

        &:focus {
          box-shadow: 0 0 0.5rem $red;
        }
      }

      &.valid {
        border-color: $green;

        &:focus {
          box-shadow: 0 0 0.5rem $green;
        }
      }
    }
  }

  .FormSelect--error {
    color:      $red;
    display:    block;
    font-size:  0.8rem;
    margin-top: 0.5rem;
    text-align: left;

    &.loading { color: $text-color-faded; }
  }
</style>
