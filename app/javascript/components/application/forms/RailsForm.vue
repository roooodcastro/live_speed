<template>
  <form
    ref="form"
    :action="action"
    :method="method"
    accept-charset="utf-8"
  >
    <input
      name="utf8"
      type="hidden"
      value="✓"
    >
    <input
      type="hidden"
      name="authenticity_token"
      :value="csrfToken"
    >
    <slot />
  </form>
</template>

<script>
  export default {
    props: {
      action: {
        type: String,
        default: '',
      },
      method: {
        type: String,
        default: 'POST',
      },
    },

    computed: {
      csrfToken() {
        return document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      },
    },

    methods: {
      submit() {
        this.$refs.form.submit();
      },
    },
  }
</script>
