<template>
    <div class="livespeed-overlay">
        <div class="livespeed-overlay-back"></div>
        <div class="livespeed-overlay-front">
            <slot></slot>
        </div>
    </div>
</template>

<script>
  export default {};
</script>

<style>
    .livespeed-overlay {
        bottom:   0;
        left:     0;
        position: absolute;
        right:    0;
        top:      0;
        z-index:  1000;
    }

    .livespeed-overlay .livespeed-overlay-back {
        background-color: rgba(0, 0, 0, 0.3);
        bottom:           0;
        left:             0;
        position:         absolute;
        right:            0;
        top:              0;
    }

    .livespeed-overlay .livespeed-overlay-front {
        bottom:   0;
        left:     0;
        position: absolute;
        right:    0;
        top:      0;
    }
</style>
