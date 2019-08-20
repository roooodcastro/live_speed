<template>
  <span
    class="CloseButton"
    @click="$emit('close')"
  >
    <span>&times;</span>
    {{ 'close' | i18n }}
  </span>
</template>

<script>
  export default {};
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .CloseButton {
    color:       $brand-gray-4;
    cursor:      pointer;
    font-size:   0.8rem;
    margin-left: 1rem;
    padding:     0.25rem;
    text-align:  center;

    &:hover {
      background-color: $brand-gray-8;
      color:            $brand-gray-3;
    }

    span {
      display:     block;
      font-size:   2em;
      line-height: 0.8em;
    }
  }
</style>
