<script setup lang="ts">
import type { Detect } from '~/shared/backend';

const props = defineProps<{
    detects: Detect[]
}>()

const emit = defineEmits<{
    (e: "detectSelected", detect: Detect): void
}>()

</script>

<template>
    <v-container class="py-0 pb-3" fluid>
        <v-card style="border-radius: 20px;" elevation="4">
            <v-card-title>AI-recognized labels based on your photo</v-card-title>
            <v-card-subtitle>Select the one you think is most appropriate</v-card-subtitle>
            <v-list>
                <div v-for="(detect, i) in detects">
                    <v-divider />
                    <v-list-item :title="detect.description"
                        :subtitle="'Score: ' + Math.round(detect.score * 10000) / 100 + '%'" 
                        @click="emit('detectSelected', detect)">
                        <template v-slot:append>
                            <p>{{ 'Confidence: ' + detect.confidence }}</p>
                        </template>
                    </v-list-item>
                </div>
            </v-list>
        </v-card>
    </v-container>
</template>