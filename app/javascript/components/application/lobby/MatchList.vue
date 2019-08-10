<template>
  <div>
    <h2>{{ t('lobby.show.matches_waiting') }}</h2>
    <ul class="MatchList__list">
      <li
        v-for="match in matches"
        :key="`match_${match.id}`"
        class="MatchList__list-item"
      >
        <span class="MatchList__status">
          {{ statusLabel(match) }}
        </span>
        <span class="MatchList__num-rounds">
          {{ roundsLabel(match) }}
        </span>
        <span class="MatchList__num-players">
          {{ playersLabel(match) }}
        </span>
        <span class="MatchList__join">
          <vue-button
            :label="t('lobby.show.join_btn')"
          />
        </span>
      </li>
    </ul>

    <div class="MatchList__quick-actions">
      <vue-button
        :label="t('lobby.show.match_me_btn')"
      />
      <vue-button
        :label="t('lobby.show.new_lobby_btn')"
      />
    </div>
  </div>
</template>

<script>
  import I18n from 'vendor/i18n-js-app.js.erb';

  export default {
    props: {
      matches: {
        type:     Array,
        required: true,
      },
    },

    methods: {
      t(name, interpolations) {
        return I18n.t(name, interpolations);
      },

      statusLabel(match) {
        const started = match.current_round > 0;
        if (started) {
          return this.t('lobby.show.match_started', { round: match.current_round, total_rounds: match.num_rounds, });
        } else {
          return this.t('lobby.show.match_not_started');
        }
      },

      roundsLabel(match) {
        return this.t('activerecord.attributes.match.rounds', { rounds: match.num_rounds, });
      },

      playersLabel(match) {
        return this.t('activerecord.attributes.match.players',
          { players: match.num_current_players, total_players: match.num_total_players, });
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .MatchList__list {
    border:          1px solid $border-color;
    padding:         0;
    list-style-type: none;
  }

  .MatchList__list-item {
    align-items:      center;
    background-color: $brand-gray-9;
    cursor:           default;
    display:          flex;
    font-weight:      bold;
    margin:           0;
    padding:          0.5rem 1rem;

    &:hover {
      background-color: $brand-gray-8;
    }

    span {
      text-align: right;
      width: 25%;
      &:first-child { text-align: left; }
    }
  }

  .MatchList__status {
    color: $brand;
  }

  .MatchList__num-rounds {
    color: $brand-alt;
  }

  .MatchList__num-players {
    color: $brand;
  }

  .MatchList__quick-actions {
    display: flex;
    justify-content: center;
  }
</style>
