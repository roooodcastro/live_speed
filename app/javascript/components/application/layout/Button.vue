<template>
  <button
    :id="id"
    :class="cssClass"
    :disabled="disabled"
    @click="click"
  >
    {{ btnLabel }}
  </button>
</template>

<script>
  export default {
    props: {
      disableWith: { type: String, default: null, },
      href:        { type: String, default: null, },
      id:          { type: String, default: null, },
      label:       { type: String, default: 'Button', },
    },

    data() {
      return {
        disabled: false,
      };
    },

    computed: {
      cssClass() {
        return 'btn';
      },

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
    },

    methods: {
      click(ev) {
        if (!this.disabled) {
          this.$emit('click', ev);
          this.disabled = !!this.disableWith;

          if (this.actsLikeALink()) window.location.href = this.href;
        }
      },
    },
  };
</script>
