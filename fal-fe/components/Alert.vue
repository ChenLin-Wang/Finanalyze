<script setup lang="ts">
import type { ResError } from '~/shared/backend';

const props = withDefaults(defineProps<{
    title: string,
    info: string | ResError | null
    timeout: number
    type?: "error" | "success" | "info" | "warning",
}>(), {
    type: "error",
    timeout: 3
})
const show = defineModel<boolean | undefined>("show")
const emit = defineEmits<{ (e: "closed"): void }>()

onMounted(() => {
    setTimeoutEff()
})

watch(show, (newValue) => {
    if (newValue === false) emit('closed');
    else setTimeoutEff()
})

const setTimeoutEff = () => {
    if (props.type !== "error") {
        setTimeout(() => {
            show.value = false;
        }, props.timeout);
    }
}
</script>

<template>
    <div>
        <v-alert v-if="info" v-model="show" border="start" close-label="Close Alert" :title="title" :type="type"
            closable>
            {{
                type === "error" ? `${(<ResError>info)?.statusCode}  (${(<ResError>info)?.data.reason})` :
                    type === "success" ? info : "Unknow"
            }}
        </v-alert>
    </div>
</template>