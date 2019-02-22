<template>
  <button
    :id="id"
    :class="cssClass"
    :disabled="disabled"
    @click="click"
  >
    {{ label }}
  </button>
</template>

<script>
  export default {
    props: {
      disableWith: { type: String, default: null },
      href:        { type: String, default: null },
      id:          { type: String, default: null },
      label:       { type: String, default: 'Button' }
    },

    data() {
      return {
        disabled: false
      };
    },

    computed: {
      cssClass() {
        return 'btn';
      },

      actsLikeALink() {
        return !!this.href;
      }
    },

    methods: {
      click(ev) {
        if (!this.disabled) {
          this.$emit('click', ev);
          this.disabled = true;

          if (this.actsLikeALink()) window.location.href = this.href;
        }
      }
    }
  };
</script>
