<script setup lang="ts">
import { be, BearerFetch, type InfoGetRes, type ResError } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { globalKeys, Paths } from '~/shared/paths';

const loading = ref(true)

export type AlertDatas = {
    info: ResError | string | null,
    type: "error" | "success" | "info" | "warning",
    title: string
}

const alertDatas = ref<AlertDatas>({
    info: null,
    type: "error",
    title: "Login Failed"
})

const { data: userInfos, error: error } = await useAsyncData("getUserInfoDatas", async () => {
    loading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.dashboard.info + '?userId=' + localStorage.getItem(be.userIdKey)) as InfoGetRes
        alertDatas.value.title = "Welcome!"
        alertDatas.value.type = "success"
        alertDatas.value.info = "Fetch user data successfully!"
        return res
    } catch (err) {
        let e = err as ResError
        alertDatas.value.title = "Something wrong!"
        alertDatas.value.type = "error"
        e.data.reason += " Jumping to Home after 3 seconds..."
        alertDatas.value.info = e
        return {
            user: {
                id: "@Error",
                email: "err@error.error"
            },
            username: "@Error",
            firstName: "@Error",
            lastName: "",
            gender: ""
        }
    } finally {
        loading.value = false
    }
})

provide(globalKeys.userInfosKey, userInfos.value)
provide(globalKeys.dashboardAlertKey, alertDatas)

onMounted(async() => {
    if (alertDatas.value.type === "error") {
        await delay(3000)
        localClear()
        useRouter().push(Paths.home)
    }
})

</script>

<template>
    <Header />
    <div style="width: 100%; height: 64px;"></div>
    <v-container fluid class="pa-0 ma-0">
        <v-row no-gutters>
            <v-col class="pa-0 ma-0" cols="auto" style="width: 256px; min-height: calc(100vh - 64px);">
                <DashboardSidebar v-if="!loading" />
                <v-skeleton-loader v-else color="white" :elevation="0"
                    class="border mx-auto pa-0 fill-height fill-width"
                    type="list-item-avatar-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider"
                    style="display: block;"></v-skeleton-loader>
            </v-col>
            <v-col cols="auto" style="display: flex;">
                <v-divider vertical style="height: 100%;"></v-divider>
            </v-col>
            <v-col>
                <Alert :type="alertDatas.type" :title="alertDatas.title" v-model:info="alertDatas.info" />
                <slot v-if="!loading" />
                <v-skeleton-loader v-else color="white" :elevation="0"
                    class="border mx-auto pa-0 fill-height fill-width" type="image, article, image, table"
                    style="display: block;"></v-skeleton-loader>
            </v-col>
        </v-row>

    </v-container>
</template>