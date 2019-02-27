<template>
  <div class="livespeed-loading-container">
    <livespeed-text
      :pos="[0, 10]"
      :size="5"
    >
      {{ loadingText }}
    </livespeed-text>
    <div class="livespeed-loading-suits">
      <span class="livespeed-loading-suit-1">
        &diams;
      </span>
      <span class="livespeed-loading-suit-2">
        &clubs;
      </span>
      <span class="livespeed-loading-suit-3">
        &hearts;
      </span>
      <span class="livespeed-loading-suit-4">
        &spades;
      </span>
    </div>
  </div>
</template>

<script>
  import I18n from 'vendor/i18n-js.js.erb';

  export default {
    props: {
      loadingText: { type: String, default: I18n.t('game.loading') }
    }
  };
</script>

<style>
  .livespeed-loading-container {
  }

  .livespeed-loading-suits {
    display:         flex;
    justify-content: center;
    font-size:       2vmin;
    left:            50%;
    position:        absolute;
    top:             50%;
    transform:       translate(-50%, calc(-50% - 5vmin));
  }

  .livespeed-loading-suits span {
    animation:   loadingsuit 1s infinite ease-in-out both;
    font-size:   5em;
    height:      1em;
    line-height: 1em;
    text-align:  center;
    text-shadow: 0 0 2px white;
    width:       0.75em;
  }

  span.livespeed-loading-suit-1 { color: #B00100; animation-delay: -0.48s; }

  span.livespeed-loading-suit-2 { color: black; animation-delay: -0.32s; }

  span.livespeed-loading-suit-3 { color: #B00100; animation-delay: -0.16s; }

  span.livespeed-loading-suit-4 { color: black; animation-delay: 0s; }

  @keyframes loadingsuit {
    0%, 80%, 100% { font-size: 1em; }
    40% { font-size: 5em; }
  }
</style>
