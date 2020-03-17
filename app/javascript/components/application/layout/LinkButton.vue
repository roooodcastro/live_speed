<template>
  <RailsForm
    v-if="renderForm"
    ref="form"
    :action="href"
    :method="method"
  >
    <button
      :id="id"
      class="btn"
      :class="cssClass"
      :disabled="isDisabled"
      type="submit"
      @click="clickSubmit"
    >
      {{ btnLabel }}
    </button>
  </RailsForm>
  <a
    v-else
    :id="id"
    class="btn"
    :class="cssClass"
    :href="href"
    :disabled="isDisabled"
    @click="clickLink"
  >
    {{ btnLabel }}
  </a>
</template>

<script>
  import RailsForm from 'components/application/forms/RailsForm';

  export default {
    components: {
      RailsForm,
    },

    props: {
      disableWith: {
        type:    String,
        default: null,
      },
      href:        {
        type:    String,
        default: null,
      },
      id:          {
        type:    String,
        default: null,
      },
      disabled:    {
        type:    Boolean,
        default: false,
      },
      label:       {
        type:    String,
        default: 'Button',
      },
      method:      {
        type:    String,
        default: 'GET',
      },
      variant:     {
        type:    String,
        default: '',
      },
    },

    data() {
      return {
        isDisabled: this.disabled,
      };
    },

    computed: {
      cssClass() {
        return [
          this.variant,
          {
            disabled: this.isDisabled,
            enabled:  !this.isDisabled,
          },
        ];
      },

      actsLikeALink() {
        return !!this.href;
      },

      btnLabel() {
        if (this.isDisabled && !this.disabled) {
          return this.disableWith;
        } else {
          return this.label;
        }
      },

      renderForm() {
        return this.method !== 'GET';
      },
    },

    methods: {
      clickSubmit(ev) {
        if (!this.isDisabled) {
          this.$emit('click', ev);
          this.isDisabled = !!this.disableWith;

          if (this.actsLikeALink) window.location.href = this.href;
          if (this.renderForm) this.$refs.form.submit();
        }
      },

      clickLink(ev) {
        if (!this.isDisabled) {
          this.$emit('click', ev);
        }
      },
    },
  };
</script>
