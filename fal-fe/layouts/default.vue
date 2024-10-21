<script setup lang="ts">
import { be, BearerFetch, type TransactionRes, type InfoGetRes, type ResError } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { getUserSpaceItem, globalKeys, Paths, userSpaceItems } from '~/shared/paths';

export type AlertDatas = {
    info: ResError | string | null,
    type: "error" | "success" | "info" | "warning",
    title: string,
    show: boolean
}

export type LoadingStatus = { sidebar: boolean, content: boolean }

const loading = ref<LoadingStatus>({ sidebar: true, content: true })
const alertDatas = ref<AlertDatas>({
    info: null,
    type: "error",
    title: "Login Failed",
    show: false
})

const userInfos = ref<InfoGetRes | null>(null)
const barTitle = ref("Account Information")
const sidebarStatus = ref(false)

provide(globalKeys.dashboardAlertKey, alertDatas)
provide(globalKeys.dashboardLoadingKey, loading)
provide(globalKeys.dashboardBarTitle, barTitle)
provide(globalKeys.dashboardSidebarStatus, sidebarStatus)
provide(globalKeys.userInfosKey, userInfos)

onBeforeMount(async () => {
    loading.value = { sidebar: true, content: true }
    try {
        const res = await BearerFetch(be.head + be.api.userspace.info) as InfoGetRes
        alertDatas.value.title = "Welcome!"
        alertDatas.value.type = "success"
        alertDatas.value.info = "Fetch user data successfully!"
        alertDatas.value.show = true
        loading.value = { sidebar: false, content: false }
        userInfos.value = res
    } catch (err) {
        let e = err as ResError
        alertDatas.value.title = "Something wrong!"
        alertDatas.value.type = "error"
        e.data.reason += ", Jumping to Home after 3 seconds..."
        alertDatas.value.info = e
        alertDatas.value.show = true
        userInfos.value = null
        await delay(3000)
        localClear()
        useRouter().push(Paths.home)
    }
})

const router = useRouter()
router.beforeEach(() => loading.value.content = true)
router.afterEach(() => loading.value.content = false)

</script>

<template>
    <v-app-bar color="black" :elevation="0">
        <Header />
    </v-app-bar>
    <v-navigation-drawer v-model="sidebarStatus" class="text-black">
        <DashboardSidebar v-if="!loading.sidebar" />
        <v-skeleton-loader v-else color="white" :elevation="0" class="border mx-auto pa-0 fill-height fill-width"
            type="list-item-avatar-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider"
            style="display: block;" />
    </v-navigation-drawer>
    <v-main>
        <v-container fluid class="pa-0 ma-0">
            <v-row no-gutters>
                <v-col style="position: relative">
                    <Alert style="position: absolute; max-width: 400px; right: 0px; top: 10px; z-index: 10;" :type="alertDatas.type" :title="alertDatas.title" :info="alertDatas.info"
                        v-model:show="alertDatas.show" :timeout="3000" />
                    <v-row v-if="barTitle !== ''" no-gutters>
                        <v-col cols="auto">
                            <v-btn icon="mdi-dock-left" @click="sidebarStatus = !sidebarStatus" variant="text"/>
                        </v-col>
                        <v-col>
                            <v-card-title class="ml-1 pl-1"><strong>{{ barTitle }}</strong></v-card-title>
                        </v-col>
                    </v-row>
                    <v-divider v-if="barTitle !== ''" />
                    <div v-if="!loading.content" :style="`overflow: scroll; height: ${barTitle !== '' ? 'calc(100vh - 64px - 49px)' : 'calc(100vh - 64px);'};`">
                        <slot />
                    </div>
                    <v-skeleton-loader v-else color="white" :elevation="0"
                        class="border mx-auto pa-0 fill-height fill-width" type="image, article, image, table"
                        style="display: block;" />
                </v-col>
            </v-row>
        </v-container>
    </v-main>
</template>

<style lang="css" scoped>
* {
    animation: none !important;
    transition: none !important;
}
</style>