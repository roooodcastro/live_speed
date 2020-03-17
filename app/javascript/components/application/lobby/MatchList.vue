<template>
  <div>
    <NewCPUMatchForm
      ref="newCPUMatchForm"
    />

    <NewMatchForm
      ref="newMatchForm"
    />

    <h2>{{ title | i18n }}</h2>

    <div v-if="matches.length > 0">
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
          <span
            v-if="canJoin(match)"
            class="MatchList__join"
          >
            <LinkButton
              :label="t('lobby.show.join_btn')"
              :disable-with="t('lobby.show.join_btn_wait')"
              :href="match.join_url"
              method="POST"
            />
          </span>
          <span
            v-else
            class="MatchList__join"
          >
            <LinkButton
              :label="t('lobby.show.play_btn')"
              :href="r('match_path', match.id)"
            />
          </span>
        </li>
      </ul>
    </div>

    <RailsAlert
      v-else
      :title="emptyTitle | i18n"
      :closeable="false"
      type="warning"
    />

    <div
      v-if="newMatchControls"
      class="MatchList__quick-actions"
    >
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
  import RailsAlert      from 'components/application/layout/RailsAlert';

  export default {
    components: {
      LinkButton,
      NewMatchForm,
      NewCPUMatchForm,
      RailsAlert,
    },

    props: {
      matches:          {
        type:     Array,
        required: true,
      },
      title:            {
        type:     String,
        required: true,
      },
      emptyTitle:       {
        type:    String,
        default: null,
      },
      newMatchControls: {
        type:    Boolean,
        default: true,
      },
      playerId: {
        type: String,
        required: true,
      },
    },

    methods: {
      statusLabel(match) {
        const started = match.current_round > 0;
        if (started) {
          return this.t('lobby.show.match_started', { round: match.current_round, total_rounds: match.num_rounds, });
        } else if (match.finished) {
          return this.t('lobby.show.match_finished');
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

      canJoin(match) {
        const matchFull = match.num_current_players >= match.num_total_players;
        const playerInMatch = match.player_ids.includes(this.playerId);
        return !matchFull && !playerInMatch;
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
    margin-top:      1rem;
  }

  @media (max-width: 575px) {
    .MatchList__quick-actions {
      flex-direction:  column;
      justify-content: stretch;

      .btn {
        margin: 0;
        width:  100%;
      }

      .btn + .btn { margin-top: 0.5rem; }
    }
  }
</style>
