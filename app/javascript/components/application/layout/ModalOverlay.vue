<template>
  <div
    v-show="opened"
    ref="overlay"
    class="ModalOverlay"
    @click="overlayClick"
  >
    <div class="ModalOverlay__modal-container">
      <div class="ModalOverlay__modal">
        <div class="ModalOverlay__modal-header">
          <h3>{{ title | i18n }}</h3>
          <CloseButton @close="close" />
        </div>
        <div class="ModalOverlay__modal-body">
          <slot />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import CloseButton from 'components/application/layout/CloseButton';

  export default {
    components: {
      CloseButton,
    },

    props: {
      closable:    {
        type:    Boolean,
        default: true,
      },
      title:       {
        type:     String,
        required: true,
      },
      startOpened: {
        type:    Boolean,
        default: false,
      },
    },

    data() {
      return {
        opened: this.startOpened,
      };
    },

    methods: {
      open() {
        this.opened = true;
      },

      close() {
        this.opened = false;
      },

      overlayClick(ev) {
        if (ev.target === this.$refs.overlay) {
          this.close();
        }
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables.scss';

  .ModalOverlay {
    align-items:      center;
    background-color: rgba(black, 0.5);
    bottom:           0;
    display:          flex;
    justify-content:  center;
    left:             0;
    position:         fixed;
    right:            0;
    top:              0;
  }

  .ModalOverlay__modal {
    background-color: $brand-gray-9;
    border:           1px solid $border-color;
  }

  .ModalOverlay__modal-header {
    display:         flex;
    flex-direction:  row;
    justify-content: space-between;
    padding:         0.75rem 0.75rem 0 0.75rem;

    h3 {
      border-bottom: 1px solid $border-color;
      flex-grow:     1;
      margin:        auto 0 auto 0;
      padding:       0 0.5rem 0.5rem 0.5rem;
    }
  }

  .ModalOverlay__modal-body {
    padding: 1rem;
  }

  @media (max-width: 575px) {
    .ModalOverlay__modal-container {
      width: 100%;
    }

    .ModalOverlay__modal {
      display:        flex;
      margin:         0 0.75rem;
      flex-direction: column;
    }
  }
</style>
