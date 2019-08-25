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
      :class="variant"
      :disabled="disabled"
      type="submit"
      @click="click"
    >
      {{ btnLabel }}
    </button>
  </RailsForm>
  <a
    v-else
    :id="id"
    class="btn"
    :class="variant"
    :href="href"
    :disabled="disabled"
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
      label:       {
        type:    String,
        default: 'Button',
      },
      method: {
        type: String,
        default: 'GET',
      },
      variant: {
        type: String,
        default: '',
      },
    },

    data() {
      return {
        disabled: false,
      };
    },

    computed: {
      actsLikeALink() {
        return !!this.href;
      },

      btnLabel() {
        if (this.disabled) {
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
      click(ev) {
        if (!this.disabled) {
          this.$emit('click', ev);
          this.disabled = !!this.disableWith;

          if (this.actsLikeALink) window.location.href = this.href;
          if (this.renderForm) this.$refs.form.submit();
        }
      },
    },
  };
</script>
