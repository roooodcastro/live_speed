<template>
  <div>
    <NewCPUMatchForm
      ref="newCPUMatchForm"
    />

    <NewMatchForm
      ref="newMatchForm"
    />

    <h2>{{ 'lobby.show.matches_waiting' | i18n }}</h2>
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
          <LinkButton
            :label="t('lobby.show.join_btn')"
            :disable-with="t('lobby.show.join_btn_wait')"
            :action="match.join_url"
            method="POST"
          />
        </span>
      </li>
    </ul>

    <div class="MatchList__quick-actions">
      <LinkButton
        variant="btn-lg"
        :label="t('lobby.show.play_cpu_btn')"
        @click="openNewCPUMatchForm"
      />
      <LinkButton
        variant="btn-alt btn-lg"
        :label="t('lobby.show.new_lobby_btn')"
        @click="openNewMatchForm"
      />
    </div>
  </div>
</template>

<script>
  import LinkButton      from 'components/application/layout/LinkButton';
  import NewMatchForm    from 'components/application/forms/NewMatchForm';
  import NewCPUMatchForm from 'components/application/forms/NewCPUMatchForm';

  export default {
    components: {
      LinkButton,
      NewMatchForm,
      NewCPUMatchForm,
    },

    props: {
      matches: {
        type:     Array,
        required: true,
      },
    },

    methods: {
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

      openNewCPUMatchForm() {
        this.$refs.newCPUMatchForm.open();
      },

      openNewMatchForm() {
        this.$refs.newMatchForm.open();
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
    background-color: $brand-gray-8;
    cursor:           default;
    display:          flex;
    font-weight:      bold;
    margin:           0;
    padding:          0.5rem 1rem;

    &:nth-child(even) {
      background-color: $brand-gray-9;
    }

    &:hover {
      background-color: $brand-gray-7;
    }

    span {
      text-align: right;
      width:      25%;

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
    display:         flex;
    justify-content: center;
  }
</style>
