<template>
    <div class="loading-container">
        <div class="loading-text">
            {{loadingText}}&hellip;
        </div>
        <div class="loading-suits">
            <span class="loading-suit-1">&diams;</span>
            <span class="loading-suit-2">&clubs;</span>
            <span class="loading-suit-3">&hearts;</span>
            <span class="loading-suit-4">&spades;</span>
        </div>
    </div>
</template>

<script>
  export default {
    props: {
      loadingText: { type: String, default: 'Loading' }
    }
  };
</script>

<style>
    .loading-container {
        left:     calc(50% - 7.5em);
        position: absolute;
        top:      calc(50% - 4em);
    }

    .loading-text {
        color:       white;
        font-family: 'Maiden Orange', serif;
        font-size:   3em;
        height:      1em;
        line-height: 1em;
        text-align:  center;
        text-shadow: 1px 1px 2px black;
    }

    .loading-suits { display: flex; justify-content: center; }

    .loading-suits span {
        animation:   0.9s infinite normal loadingsuit;
        font-size:   5em;
        height:      1em;
        line-height: 1em;
        text-align:  center;
        text-shadow: 0 0 2px white;
        width:       0.75em;
    }

    span.loading-suit-1 { color: #B00100; }

    span.loading-suit-2 { color: black; animation-delay: 0.12s; }

    span.loading-suit-3 { color: #B00100; animation-delay: 0.24s; }

    span.loading-suit-4 { color: black; animation-delay: 0.36s; }

    @keyframes loadingsuit {
        0% { font-size: 2.5em; }
        20% { font-size: 2.5em; }
        50% { font-size: 5em; }
        80% { font-size: 2.5em; }
        100% { font-size: 2.5em; }
    }
</style>
