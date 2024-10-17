<script setup lang="ts">
import type { AlertDatas } from '~/layouts/default.vue';
import { be, BearerFetch, type AiAnsRes, type ResError } from '~/shared/backend';
import { dateFormat } from '~/shared/dateFunctions';
import { delay, localClear } from '~/shared/funcs';
import { globalKeys, Paths } from '~/shared/paths';

const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)

barTitle.value = "Ai Bot"

const chats = ref<AiAnsRes[]>([])
const chatSideBarLoading = ref(true)
const chatLoading = ref(true)
const chatWaiting = ref(false)

const chatView = ref(null)

const newC = ref(true)

const chat = ref({ id: "", title: "", contents: [], createdAt: "", updatedAt: "" } as AiAnsRes)

onBeforeMount(async () => {
    chatSideBarLoading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.userspace.ai.chats_get) as AiAnsRes[]
        chats.value = res
        chatSideBarLoading.value = false
    } catch (err) {
        errHandle(err as ResError)
    }
})

const errHandle = async (e: ResError) => {
    alertDatas.value.title = "Something wrong!"
    alertDatas.value.type = "error"
    e.data.reason += ", Jumping to Home after 3 seconds..."
    alertDatas.value.info = e
    alertDatas.value.show = true
    // await delay(3000)
    // localClear()
    // useRouter().push(Paths.home)
    chatSideBarLoading.value = false
}

const chatSelected = async (id: string) => {
    newC.value = false
    chatLoading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.userspace.ai.chat + "?id=" + id) as AiAnsRes
        console.log(res)
        chat.value = res
        chatLoading.value = false
    } catch (err) {
        errHandle(err as ResError)
    }
}

const send = async (text: string) => {
    if (newC.value) {
        newC.value = false
        chatLoading.value = true
        try {
            const res = await BearerFetch(be.head + be.api.userspace.ai.chat, {
                method: "PUT",
                body: { ques: text }
            }) as AiAnsRes
            chats.value = [res].concat(chats.value)
            chatLoading.value = false
            chatWaiting.value = true;
            chat.value = res
        } catch (err) {
            errHandle(err as ResError)
        }
    }

    chat.value.contents.push({ role: "user", content: text });
    (chatView.value as any).scrollToBottom()
    chats.value.filter( a => a.id === chat.value.id )[0].updatedAt = dateFormat(Date())
    try {
        const res = await BearerFetch(be.head + be.api.userspace.ai.chat, {
            method: "POST",
            body: { id: chat.value.id, ques: text }
        }) as string
        chat.value.contents.push({ role: "model", content: res })
        chatWaiting.value = false;
        (chatView.value as any).scrollToBottom()
    } catch (err) {
        errHandle(err as ResError)
    }
}

const del = async (id: string) => {
    try {
        const res = await BearerFetch(be.head + be.api.userspace.ai.chat, {
            method: "DELETE",
            body: { id: id }
        }) as string
        chats.value = chats.value.filter( a => a.id !== id );
        if (chat.value.id === id) newC.value = true
    } catch (err) {
        errHandle(err as ResError)
    }
}

</script>

<template>
    <v-row class="fill-height" no-gutters>
        <v-col>
            <DashboardAiChat ref="chatView" :new-chat="newC" :chat="chat" v-model:waiting="chatWaiting"
                :loading="chatLoading" @send="send" />
        </v-col>
        <v-divider vertical />
        <v-col cols="auto" style="width: 250px">
            <DashboardAiChatList :chats="chats" :loading="false" @chat-selected="chatSelected" @new-chat="newC = true" @delete="del"/>
        </v-col>
    </v-row>
</template>