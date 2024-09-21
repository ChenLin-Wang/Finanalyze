<script setup lang="ts">
import type { ResError } from '~/shared/backend';

const props = withDefaults(defineProps<{
    title: string,
    type?: "error" | "success" | "info" | "warning",
}>(), {
    type: "error",
    alert: true,
    style: "error"
})
const info = defineModel<string | ResError | null>("info")
const alert = ref(info !== null)
const emit = defineEmits<{ (e: "closed"): void }>()

watch(alert, (newValue) => {
    if (newValue === false) {
        info.value = null
        emit('closed');
    }
})
</script>

<template>
    <div>
        <v-alert 
            v-if="info"
            v-model="alert"
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