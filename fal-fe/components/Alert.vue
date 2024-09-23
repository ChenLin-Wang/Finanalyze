<script setup lang="ts">
import type { ResError } from '~/shared/backend';

const props = withDefaults(defineProps<{
    title: string,
    info: string | ResError | null
    type?: "error" | "success" | "info" | "warning",
}>(), {
    type: "error",
})
const show = defineModel<boolean | undefined>("show")
const emit = defineEmits<{ (e: "closed"): void }>()

watch(show, (newValue) => {
    if (newValue === false) {
        emit('closed');
    }
})
</script>

<template>
    <div>
        <v-alert 
            v-if="info"
            v-model="show"
            border="start" 
            close-label="Close Alert" 
            :title="title" 
            :type="type"
            closable
        >
            {{  
                type === "error" ? (<ResError>info)?.statusCode + ' ' + (<ResError>info)?.data.reason :
                type === "success" ? info : "Unknow" 
            }} 
        </v-alert>
    </div>
</template>