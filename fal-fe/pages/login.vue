<script setup lang="ts">
definePageMeta({
    layout: 'plain'
})
</script>

<template>
    <v-container fluid class="ma-0 pa-0">
        <v-row class="ma-0 pa-0" style="min-height: 100vh;" align="center" justify="center"> 
            <v-col>
                <AuthLogin class="ma-5"></AuthLogin>
            </v-col>
        </v-row>
    </v-container>
</template>