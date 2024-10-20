<script setup lang="ts">
import type { Detail } from '~/components/Dashboard/DetectDetail.vue';
import type { TransactionValue } from '~/components/Dashboard/TransactionConvertor';
import type { AlertDatas } from '~/layouts/default.vue';
import { be, BearerFetch, type Detect, type FileUploadRes, type ResError, type TransactionRes } from '~/shared/backend';
import { dateFormat } from '~/shared/dateFunctions';
import { globalKeys, Paths } from '~/shared/paths';

const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)
const sidebarStatus = ref(inject(globalKeys.dashboardSidebarStatus) as boolean)

barTitle.value = ""

const detects = ref<Detect[] | null>(null)

const loading = ref(false)
const wholeLoading = ref(false)

const step = ref(0)

const transaction = ref({
    id: "",
    itemName: "",   //
    itemAmount: 1,  //
    pricePerUnit: 1,    //
    location: "",   
    category: "Food",   //
    __transactionDate: dateFormat(Date(), "YYYY-MM-DD"), //
} as TransactionValue)

const getImage = async (img: File) => {
    loading.value = true
    try {
        const formData = new FormData();
        formData.append('data', img)
        formData.append('name', img.name)
        formData.append('detect', 'true')
        const res = await BearerFetch(be.head + be.api.userspace.files + "/item", {
            "Content-Type": "multipart/form-data",
            method: "POST",
            body: formData
        }) as FileUploadRes
        detects.value = res.detect
        transaction.value.__transactionDate = dateFormat(new Date(img.lastModified), "YYYY-MM-DD")
        // @ts-ignore 
        transaction.value.imgPath = res.id
        step.value = 1
        loading.value = false
    } catch (err) {
        errHandle(err as ResError)
    }
}

const getDetect = (detect: Detect) => {
    transaction.value.itemName = detect.description
    step.value += 1
}

const detailApplied = (detail: Detail) => {
    transaction.value.itemAmount = +detail.amount
    transaction.value.pricePerUnit = +detail.totalPrice / +detail.amount
    transaction.value.brand = detail.brand
    transaction.value.category = detail.category
    step.value += 1
    photoDone()
}

const photoDone = () => {
    step.value = 0
}

const submit = async (transaction: TransactionValue, i: number) => {
    wholeLoading.value = true
    try {
        const _ = await BearerFetch(be.head + be.api.userspace.transactions.normal, {
            method: "PUT",
            body: transaction
        }) as TransactionRes
        step.value = 0
        successHandle()
        useRouter().push(Paths.transactions)
        wholeLoading.value = false
    } catch (err) {
        errHandle(err as ResError)
    }
}

const successHandle = () => {
    alertDatas.value.title = "Success!"
    alertDatas.value.type = "success"
    alertDatas.value.info = "Operation Success!"
    alertDatas.value.show = true
    // loading.value = false
    // checkCurPageIndex()
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
    // loading.value = false
}

</script>

<template>
    <v-row no-gutters>
        <v-col cols="auto">
            <v-btn @click="sidebarStatus = !sidebarStatus" icon="mdi-dock-left" variant="text" />
        </v-col>
        <v-col>
            <v-card-title class="ml-1 pl-1"><strong>New Transaction</strong></v-card-title>
        </v-col>
        <v-col cols="auto">
            <v-btn icon="mdi-close-box-outline" @click="useRouter().push(Paths.transactions)" variant="text" />
        </v-col>
    </v-row>
    <v-divider />
    <v-container v-if="!wholeLoading" fluid class="pa-0" style="height: calc(100% - 49px)">
        <v-row no-gutters>
            <v-col cols="12">
                <v-card-title>1. Upload Photo</v-card-title>
                <DashboardPhoto @useImage="getImage" />
                <DashboardDetectList v-if="!loading && step === 1 && detects" :detects="detects" @detectSelected="getDetect" />
                <DashboardDetectDetail v-if="!loading && step === 2" @detailApplied="detailApplied" />
                <v-skeleton-loader v-if="loading" color="white" :elevation="0" class="ma-3 border pa-0 fill-width" type="card"
                    style="height: 300px" />
            </v-col>
        </v-row>
        <v-row no-gutters align="center">
            <v-col><v-divider /></v-col>
            <v-col cols="auto">
                <p>Or</p>
            </v-col>
            <v-col><v-divider /></v-col>
        </v-row>
        <v-row no-gutters>
            <v-col cols="12">
                <v-card-title>2. Manually</v-card-title>
                <dashboard-transaction-form :editable="true" :noPicture="true" :deletable="false" @submit="submit" :transaction="transaction" :i="0" :alwaysEnableSubmit="true"/>
            </v-col>
        </v-row>
    </v-container>
    <v-skeleton-loader v-else color="white" :elevation="0" class="ma-0 border pa-0 fill-width fill-height" type="card, card, table"/>
</template>