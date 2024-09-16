<template>
    <h1 class="bar-title">Finanalyze</h1>
</template>

<script setup>
import { Fonts } from '../shared/fonts'
const setCSSVariables = () => document.documentElement.style.setProperty('--brand-title', Fonts.BrandTitle)
onMounted(setCSSVariables)
</script>

<style lang="css" scoped>
.bar-title {
    font-family: var(--brand-title);
    font-size: 30px;
    font-weight: 400;
}
</style>