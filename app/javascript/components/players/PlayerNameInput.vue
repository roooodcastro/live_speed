<template>
  <div class="player-name-input">
    <input type="text" :value="name" @input="debouncedValidateName"/>
    <span class="player-name-input-error-message" v-show="error.length > 0">{{ error }}</span>
  </div>
</template>

<script>
  import axios         from 'axios';
  import { debounced } from 'helpers/forms';

  const api = axios.create({
    baseURL: '/player_name_validators'
  });

  export default {
    props: {
      initialName: { type: String, default: '' }
    },

    data() {
      return {
        name:  this.initialName,
        error: ''
      };
    },

    created() {
      this.debouncedValidateName = debounced(500, this.validateName);
    },

    methods: {
      validateName(ev) {
        this.name = ev.target.value;
        api
          .post('/', { name: this.name })
          .catch(() => Promise.reject(['Unexpected error. Please contact an administrator.']))
          .then(({ data }) => {
            this.error = data.error;
          });
      }
    }
  };
</script>

<style lang="scss">
  @import 'stylesheets/forms.scss';

  .player-name-input {
  }
</style>
