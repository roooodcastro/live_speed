<template>
    <div id="game_table" class="game-table-container">
        <livespeed-playingcard :initial-position="[-40, -80]"></livespeed-playingcard>

        <livespeed-playingcard :initial-position="[10, -80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[5, -80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[0, -80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[-5, -80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[-10, -80]"></livespeed-playingcard>

        <livespeed-playingcard :initial-position="[-40, 0]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[-10, 0]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[10, 0]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[40, 0]"></livespeed-playingcard>

        <livespeed-playingcard :initial-position="[-10, 80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[-5, 80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[0, 80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[5, 80]"></livespeed-playingcard>
        <livespeed-playingcard :initial-position="[10, 80]"></livespeed-playingcard>

        <livespeed-playingcard :initial-position="[40, 80]"></livespeed-playingcard>
    </div>
</template>

<script>
  export default {
    data() { return {}; }
  }
</script>