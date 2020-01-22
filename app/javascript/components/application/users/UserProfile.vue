<template>
  <div>
    <h3 class="UserProfile__sub-header">
      User Info:
    </h3>

    <dl class="UserProfile__info-dl">
      <dt>Name</dt>
      <dd>{{ name }}</dd>

      <dt>Email</dt>
      <dd>{{ email }}</dd>
    </dl>

    <LinkButton
      :href="destroyPath"
      label="Delete Account"
      method="DELETE"
      variant="btn-danger"
    />
  </div>
</template>

<script>
import LinkButton from 'components/application/layout/LinkButton';

export default {
  components: {
    LinkButton,
  },

  props: {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    destroyPath: {
      type: String,
      required: true,
    },
  },

  computed: {},

  methods: {},
};
</script>

<style lang="scss">
.UserProfile_sub-header {
}

.UserProfile__info-dl {
}
</style>
