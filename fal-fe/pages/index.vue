<template>
    <v-container class="text-white" style="height: 100vh;">
        <v-row align="center" class="text-center fill-height" justify="center">
            <v-col class="pa-5">
                <h1 class="web-title">Finanalyze!</h1>
                <h3 class="description-text">Your Ultimate Smart Financial Partner, Guiding You to Smarter Decisions and a Brighter Financial Future!</h3>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
import { Fonts } from '../shared/fonts'
const setCSSVariables = () => document.documentElement.style.setProperty('--brand-title', Fonts.BrandTitle)
onMounted(setCSSVariables)
</script>

<style lang="css" scoped>
.web-title {
    font-family: var(--brand-title);
    font-size: 100px;
    font-weight: 400;
}
.description-text {
    font-family: var(--brand-title);
    font-size: 20px;
    font-weight: 400;
}
</style>