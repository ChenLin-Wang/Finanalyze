<script setup lang="ts">
import type { AiAnsRes } from '~/shared/backend';
import { dateFormat } from '~/shared/dateFunctions';

const props = withDefaults(defineProps<{
    chats: AiAnsRes[],
    loading: boolean
}>(), {
    loading: true
})

const emit = defineEmits<{ 
    (e: "chatSelected", id: string): void,
    (e: "newChat"): void,
    (e: "delete", id: string): void
}>()
const chatSelected = (id: string) => emit("chatSelected", id)
const newChat = () => emit("newChat")
const del = (id: string) => emit("delete", id)

</script>

<template>
    <v-container fluid class="text-begin pa-0 ma-0 d-flex flex-column" style="height: 100%;">
        <v-list v-if="!loading" class="flex-grow-1" :lines="false" density="default"
            style="overflow: scroll; height: 0px;;" nav>
            <v-list-item lines="one" v-for="chat in chats" :key="chat.id" :value="chat.id" color="primary"
                @click="chatSelected(chat.id)">
                <v-list-item-title v-text="chat.title" />
                <v-list-item-subtitle v-text="dateFormat(chat.updatedAt)" />
                <template v-slot:append>
                    <v-btn color="red" icon="mdi-chat-remove-outline" density="compact" variant="text" @click.stop="del(chat.id)"></v-btn>
                </template>
            </v-list-item>
        </v-list>
        <div v-else class="flex-grow-1" style="overflow: scroll">
            <v-skeleton-loader color="white" :elevation="0" class="flex-skeleton"
                type="list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider"
                style="height: 0px" />
        </div>
        <v-divider />
        <div class="actions flex-shrink-0 px-3" style="padding-top: 14px; padding-bottom: 14px">
            <v-btn rounded variant="elevated" style="width: 100%;" @click="newChat"> New chat</v-btn>
        </div>
    </v-container>
</template>