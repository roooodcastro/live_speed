<template>
    <div class="game-table-gametext">{{ text }}</div>
</template>

<script>
  export default {
    props: {
      text: { type: String, required: true }
    }
  };
</script>
