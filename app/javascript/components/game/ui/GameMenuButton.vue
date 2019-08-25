<template>
  <div
    class="GameMenuButton"
    :class="{ active: menuOpened }"
    :style="style()"
    @click="onClick"
  >
    <FontAwesomeIcon icon="cogs" />
  </div>
</template>

<script>
  import { FontAwesomeIcon, } from '@fortawesome/vue-fontawesome';
  import CardCoordinate      from 'helpers/card_coordinate';

  export default {
    components: {
      FontAwesomeIcon,
    },

    props: {
      menuOpened: { type: Boolean, required: true, },
    },

    methods: {
      onClick(ev) {
        this.$emit('click', ev);
      },

      style() {
        const coordinates  = new CardCoordinate([-80, 0, ]);
        const posTransform = 'translate(' + coordinates.toString + ')';
        const fontSize = (7 * CardCoordinate.cardScale()) + 'rem';

        return { transform: posTransform, fontSize: fontSize, };
      },
    },
  };
</script>

<style lang="scss">
  @import 'stylesheets/_variables';

  .GameMenuButton {
    color:      $brand-alt;
    font-size:  2rem;
    padding:    0.5rem;
    position:   absolute;
    text-align: center;
    transition: all 0.3s;
    z-index:    1002;

    &:hover {
      background-color: $brand-alt-1;
      border-radius:    4rem;
      color:            $brand-alt-3;
      cursor:           pointer;
      padding:          0.5rem;
    }

    &.active {
      height: 1.5rem;
      bottom: 0;
    }
  }
</style>
