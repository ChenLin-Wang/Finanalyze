<script setup lang="ts">
import { ref } from 'vue'
import type { AiAnsRes } from '~/shared/backend';

const props = withDefaults(defineProps<{
    chat: AiAnsRes,
    loading: boolean,
    newChat: boolean
}>(), {
    waiting: false,
    loading: true,
    newChat: true
})

const waiting = defineModel<boolean>("waiting")

const emit = defineEmits<{
    (e: "send", text: string): void
}>()
const input = ref('')

const chatContainer = ref<HTMLElement | null>(null)

const sendMessage = () => {
    waiting.value = true;
    nextTick(() => {
        emit("send", input.value)
        input.value = ""
    })
}

const scrollToBottom = () => {
    if (!chatContainer.value) return
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
}

const handleKeyDown = (event: KeyboardEvent) => {
    const isMac = navigator.userAgent.includes('Mac')
    if ((isMac ? event.metaKey : event.ctrlKey) && event.key === 'Enter') {
        if (!waiting.value && input.value !== '') sendMessage();
    }
};

onMounted(() => {
    window.addEventListener('keydown', handleKeyDown);
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleKeyDown);
});

defineExpose({ scrollToBottom })

</script>

<template>
    <v-container fluid class="ma-0 pa-0 d-flex flex-column" style="height: 100%;">
        <div v-if="!newChat && !loading" ref="chatContainer" class="chat-content flex-grow-1 pa-3" style="height: 0px">
            <div style="border-radius: 10px;" v-for="(message, index) in chat.contents" :key="index"
                :class="(message.role === 'user' ? 'text-right' : '') + ' pa-2'">
                <v-list-item-title class="mb-1"><strong>{{ message.role === 'user' ? 'You' : 'Finanalyzer'
                        }}:</strong></v-list-item-title>
                <MDC :value="message.content" class="ma-2 markdown-content" />
                <v-divider class="mt-3"
                    :style="(message.role === 'user' ? 'margin-left: 50%;' : '') + ' width: 50%; '" />
            </div>
            <v-row align="start" v-if="waiting" justify="start" no-gutters>
                <v-col cols="6" class="pa-2">
                    <v-list-item-title class="mb-1"><strong>Finanalyzer:</strong></v-list-item-title>
                    <v-skeleton-loader color="white" :elevation="0" class="border mx-auto pa-0"
                        type="subtitle, list-item-two-line"
                        style="display: block; border-radius: 20px; border: none !important;"></v-skeleton-loader>
                </v-col>
            </v-row>
        </div>
        <div v-else-if="!newChat" class="flex-grow-1" style="overflow: scroll">
            <v-skeleton-loader color="white" :elevation="0" class="flex-skeleton"
                type="article, sentences, article, paragraph" style="height: 0px" />
        </div>
        <div v-else class="flex-grow-1">
            <v-row no-gutters style="height: 100%;" align="center" justify="center">
                <v-col class="text-center" cols="auto">
                    <h2>Welcome, Type your question to start!</h2>
                </v-col>
            </v-row>
        </div>
        <v-divider />
        <div class="actions flex-shrink-0">
            <v-card-actions align="center" justify="center">
                <v-textarea v-model="input" label="Send message" hide-details single-line dense density="comfortable"
                    variant="solo" rounded class="flex-grow-1" auto-grow rows="1" max-rows="5">
                    <template #append-inner>
                        <v-row no-gutters class="fill-height ma-0 pa-0" align="end" justify="end">
                            <v-col>
                                <v-btn icon @click="sendMessage" color="black" :disabled="waiting || input === ''">
                                    <v-icon size="20">mdi-send</v-icon>
                                </v-btn>
                            </v-col>
                        </v-row>
                    </template>
                </v-textarea>
            </v-card-actions>
        </div>
    </v-container>
</template>

<style scoped>
.chat-content {
    overflow: scroll;
    width: 100%;
}

.actions {
    overflow: hidden;
    width: 100%;
}
</style>