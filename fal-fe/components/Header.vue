<script setup lang="ts">
import { Paths } from '~/shared/paths';

const props = withDefaults(defineProps<{
    showButton?: boolean
}>(), {
    showButton: false
})
</script>

<template>
    <Logo class="mx-3"></Logo>
    <v-spacer></v-spacer>
    <v-btn v-if="showButton" rounded="t-xl" class="bg-white" icon="mdi-login-variant"
        @click="useRouter().push(Paths.login)"></v-btn>
    <v-btn v-if="showButton" rounded="t-xl" class="bg-white ms-2" icon="mdi-account-plus-outline"
        @click="useRouter().push(Paths.register)"></v-btn>
</template>