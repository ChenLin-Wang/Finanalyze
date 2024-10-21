<script setup lang="ts">
import type { ViewOption } from '~/components/Dashboard/ViewOptions.vue';
import type { AlertDatas } from '~/layouts/default.vue';
import { be, BearerFetch, type CategoryRes, type ResError, type SummaryRes, type TimelineRes } from '~/shared/backend';
import { dateFormat } from '~/shared/dateFunctions';
import { delay, localClear } from '~/shared/funcs';
import { globalKeys, Paths } from '~/shared/paths';

const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)
const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
barTitle.value = "Dashboard"

// @ts-ignore
const summaryData = ref<SummaryRes>({})
const timeLineDatas = ref<TimelineRes[]>([])
const categoryDatas = ref<CategoryRes[]>([])
const viewOption = ref({
    by: "Monthly",
    startDate: undefined,
    duration: undefined
} as ViewOption)
const loading = ref(true)

var curCosterColors: string[] = []
var curCounterColors: string[] = []

const zones = {
    "Daily": "daily",
    "Monthly": "monthly",
    "Yearly": "yearly"
}

onBeforeMount(() => load())

const load = async () => {
    loading.value = true
    try {
        const queryStr = 
            `?zone=${zones[viewOption.value.by]}` + 
            (viewOption.value.duration && viewOption.value.startDate ? `&range=${viewOption.value.duration}&start=${dateFormat(viewOption.value.startDate, "YYYY-MM-DD")}` : "")
        summaryData.value = await BearerFetch(be.head + be.api.userspace.overview.summary) as SummaryRes
        timeLineDatas.value = await BearerFetch(be.head + be.api.userspace.overview.timeline + queryStr) as TimelineRes[]
        categoryDatas.value = await BearerFetch(be.head + be.api.userspace.overview.category + queryStr) as CategoryRes[]
        curCosterColors = categoryDatas.value.map(a => costerColors[a.name as keyof typeof costerColors])
        curCounterColors = categoryDatas.value.map(a => counterColors[a.name as keyof typeof counterColors])
        loading.value = false
    } catch (err) {
        errHandle(err as ResError)
    }
}

const errHandle = async (e: ResError) => {
    alertDatas.value.title = "Something wrong!"
    alertDatas.value.type = "error"
    e.data.reason += ", Jumping to Home after 3 seconds..."
    alertDatas.value.info = e
    alertDatas.value.show = true
    // await delay(3000)
    // localClear()
    // useRouter().push(Paths.home)
    loading.value = false
}

const viewOptionChanged = () => {
    nextTick(async () => {
        await load()
    })
}

const costerColors = {
    "Food": "#FF6F61",             // Coral
    "Clothing": "#D1C4E9",         // Lavender
    "Shelter": "#81C784",          // Light Green
    "Utilities": "#64B5F6",        // Light Blue
    "Transportation": "#FFB74D",   // Light Orange
    "Healthcare": "#FF8A80",       // Light Red
    "Education": "#90CAF9",        // Light Sky Blue
    "Entertainment": "#CE93D8",    // Light Purple
    "Electronics": "#B2DFDB",      // Light Teal
    "Furniture": "#FFE082",        // Light Yellow
    "Household Appliances": "#FFCCBC", // Light Peach
    "Personal Care Products": "#E1BEE7", // Light Pink
    "Luxury Goods": "#FFECB3",     // Light Gold
    "Sports Equipment": "#A5D6A7", // Light Green
    "Travel": "#BBDEFB",           // Light Blue
    "Financial Services": "#B3E5FC", // Light Cyan
    "Insurance": "#FFABAB",        // Light Salmon
    "Communication Devices": "#F0E68C", // Khaki
    "Subscription Services": "#B2DFDB", // Light Teal
    "Books and Media": "#FFF9C4"   // Light Yellow
}

const counterColors = {
    "Food": "#F7B733",             // Sunflower
    "Clothing": "#9575CD",         // Purple
    "Shelter": "#388E3C",          // Green
    "Utilities": "#1E88E5",        // Blue
    "Transportation": "#FF9800",   // Orange
    "Healthcare": "#D32F2F",       // Red
    "Education": "#42A5F5",        // Sky Blue
    "Entertainment": "#9C27B0",    // Purple
    "Electronics": "#00796B",      // Teal
    "Furniture": "#FFC107",        // Amber
    "Household Appliances": "#FF5722", // Deep Orange
    "Personal Care Products": "#D81B60", // Pink
    "Luxury Goods": "#FFC107",     // Gold
    "Sports Equipment": "#388E3C", // Dark Green
    "Travel": "#2196F3",           // Blue
    "Financial Services": "#03A9F4", // Cyan
    "Insurance": "#FF5722",        // Deep Orange
    "Communication Devices": "#FBC02D", // Yellow
    "Subscription Services": "#00796B", // Teal
    "Books and Media": "#FBC02D"   // Yellow
}

</script>

<template>
    <v-row v-if="!loading" no-gutters style="height: calc(100% - 65px)">
        <v-col class="pa-2" cols="6" style="height: 50%;">
            <v-card class="fill-height">
                <DashboardSummaryDeck :summary="summaryData" style="min-height: 100%; max-height: 100%;" />
            </v-card>
        </v-col>
        <v-col class="pa-2" cols="6" style="height: 50%;">
            <v-card class="fill-height">
                <DashboardTimeLinePlot v-if="timeLineDatas.length > 0" :datas="timeLineDatas" style="min-height: 100%; max-height: 100%;" />
                <DashboardNull v-else label="Transactions" />
            </v-card>
        </v-col>
        <v-col class="pa-2" cols="8" style="height: 50%;">
            <v-card class="fill-height">
                <DashboardCategoryPlot v-if="categoryDatas.length > 0" :coster-colors="curCosterColors" :counter-colors="curCounterColors"
                    :datas="categoryDatas" style="min-height: 100%; max-height: 100%;" />
                <DashboardNull v-else label="Transactions" />
            </v-card>
        </v-col>
        <v-col class="pa-2" cols="4" style="height: 50%;">
            <v-card class="fill-height">
                <DashboardPiePlot v-if="categoryDatas.length > 0" :total-cost="categoryDatas.map(a => a.costWeight).reduce((a, c) => a + c, 0)"
                    :total-count="categoryDatas.map(a => a.countWeight).reduce((a, c) => a + c, 0)"
                    :coster-colors="curCosterColors" :counter-colors="curCounterColors" :datas="categoryDatas"
                    style="min-height: 100%; max-height: 100%;" />
                <DashboardNull v-else label="Transactions" />
            </v-card>
        </v-col>
    </v-row>
    <v-skeleton-loader v-else color="white" style="height: calc(100% - 65px)" :elevation="0"
        class="border mx-auto pa-0 fill-width" type="card, card" />
    <v-divider />
    <v-row class="px-1" no-gutters style="height: 64px; width: 100%" align="center" justify="center">
        <v-spacer/>
        <v-col cols="auto">
            <DashboardViewOptions v-model="viewOption" @view-option-changed="viewOptionChanged"/>
        </v-col>
    </v-row>
</template>