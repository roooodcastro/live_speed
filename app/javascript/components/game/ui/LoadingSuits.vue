<template>
  <div class="LoadingSuits">
    <GameText
      :pos="[0, 10]"
      :size="5"
    >
      {{ loadingText }}
    </GameText>
    <div class="LoadingSuits__suits">
      <span class="LoadingSuits__suit-1">
        &diams;
      </span>
      <span class="LoadingSuits__suit-2">
        &clubs;
      </span>
      <span class="LoadingSuits__suit-3">
        &hearts;
      </span>
      <span class="LoadingSuits__suit-4">
        &spades;
      </span>
    </div>
  </div>
</template>

<script>
  import GameText from 'components/game/ui/GameText';

  import I18n from 'vendor/i18n-js-game.js.erb';

  export default {
    components: {
      GameText,
    },

    props: {
      loadingText: { type: String, default: I18n.t('game.loading'), },
    },
  };
</script>

<style>
  .LoadingSuits {
  }

  .LoadingSuits__suits {
    display:         flex;
    justify-content: center;
    font-size:       2vmin;
    left:            50%;
    position:        absolute;
    top:             50%;
    transform:       translate(-50%, calc(-50% - 5vmin));
  }

  .LoadingSuits__suits span {
    animation:   LoadingSuit--animation 1s infinite ease-in-out both;
    font-size:   5em;
    height:      1em;
    line-height: 1em;
    text-align:  center;
    text-shadow: 0 0 2px white;
    width:       0.75em;
  }

  span.LoadingSuits__suit-1 { color: #B00100; animation-delay: -0.48s; }

  span.LoadingSuits__suit-2 { color: black; animation-delay: -0.32s; }

  span.LoadingSuits__suit-3 { color: #B00100; animation-delay: -0.16s; }

  span.LoadingSuits__suit-4 { color: black; animation-delay: 0s; }

  @keyframes LoadingSuit--animation {
    0%, 80%, 100% { font-size: 1em; }
    40% { font-size: 5em; }
  }
</style>
