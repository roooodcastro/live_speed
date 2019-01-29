<template>
    <button class="game-button" @click="click"><slot></slot></button>
</template>

<script>
  export default {
    props: {
      click: { type: Function, required: true }
    }
  };
</script>

<style>
    .game-button {
        background:    transparent;
        border:        3px solid transparent;
        border-radius: .5em;
        color:         rgba(255, 255, 255, 0.6);
        font-size:     1.5em;
        font-family:   Arial, sans-serif;
        line-height:   2em;
        margin:        0 10px;
        min-width:     10em;
        outline:       none;
        padding:       0 1em;
        position:      relative;
        transform:     translate(50vw, 65vh);
        transition:    0.2s;
    }

    .game-button:hover { color: rgba(255, 255, 255, 0.9); }

    .game-button::before {
        border:        3px solid rgba(255, 255, 255, 0.6);
        border-radius: .5em;
        content:       '';
        height:        100%;
        left:          0;
        position:      absolute;
        top:           0;
        transition:    transform 0.1s, border-color 0.2s;
        width:         100%;
    }

    .game-button:hover::before {
        border-color: rgba(255, 255, 255, 0.9);
        transform: scale(1.05);
    }

    .game-button:active, .game-button:focus {
        animation:  game-button-pulse 0.3s;
        box-shadow: 0 0 0 1em rgba(255, 255, 255, 0);
        outline:    none;
    }

    @keyframes game-button-pulse { 0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.5); } }
</style>