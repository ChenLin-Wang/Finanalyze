<script setup lang="ts">
const props = withDefaults(defineProps<{
    showButton?: true
}>(), {
    showButton: false
})
</script>

<template>
    <v-layout>
        <v-app-bar color="black" :elevation="4">
            <Logo class="mx-3"></Logo>
            <v-spacer></v-spacer>   
            <v-btn v-if="showButton" rounded="t-xl" class="bg-white" icon="mdi-login-variant"></v-btn>
            <v-btn v-if="showButton" rounded="t-xl" class="bg-white ms-2" icon="mdi-account-plus-outline"></v-btn>
        </v-app-bar>
    </v-layout>
</template>