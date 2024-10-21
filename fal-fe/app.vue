<script setup lang="ts">
import { FontSetup } from './shared/fonts';

onMounted(FontSetup)

useHead({ title: 'Finanalyze' })

</script>

<template>
    <v-responsive>
        <v-app>
            <NuxtLayout>
                <NuxtPage />
            </NuxtLayout>
        </v-app>
    </v-responsive>
</template>