<script setup lang="ts">
import type { TransactionValue } from '~/components/Dashboard/TransactionForm.vue';
import type { AlertDatas, LoadingStatus } from '~/layouts/default.vue';
import { be, BearerFetch, type ResError, type TransactionRes } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { globalKeys, Paths } from '~/shared/paths';

const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
const transactions = ref<TransactionRes[]>([])
const loading = ref(true)
const transactionList = ref(null)
const totalCount = ref(0)
const numPerPage = ref(15)
const curPage = ref(1)
const pageCount = () => Math.ceil(totalCount.value / numPerPage.value)

const sort = ref("Date")
const descending = ref(true)

function toFormValue(value: TransactionRes): TransactionValue {
    return {
        id: value.id,
        itemName: value.itemName,
        itemAmount: +value.itemAmount,
        pricePerUnit: +value.pricePerUnit,
        location: value.location,
        brand: value.brand,
        category: value.category,
        __transactionDate: value.transactionDate.split('T')[0]
    }
}

function toFormRes(value: TransactionValue): TransactionRes {
    return {
        id: value.id,
        itemName: value.itemName,
        itemAmount: +value.itemAmount,
        pricePerUnit: +value.pricePerUnit,
        location: value.location,
        brand: value.brand,
        category: value.category,
        transactionDate: value.__transactionDate
    }
}

onBeforeMount(async () => await loadTransactions())

const submit = async (transaction: TransactionValue, i: number) => {
    // loading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.userspace.transactions, {
            method: "POST",
            body: transaction
        })
        // await loadTransactions()
        transactions.value[i] = toFormRes(transaction);
        (transactionList.value as any).closeAllDetails()
        successHandle()
    } catch (err) {
        errHandle(err as ResError)
    }
}

const del = async (transaction: TransactionValue, i: number) => {
    try {
        const res = await BearerFetch(be.head + be.api.userspace.transactions, {
            method: "DELETE",
            body: { id: transaction.id }
        })
        transactions.value = transactions.value.filter((_, ind) => ind !== i);
        (transactionList.value as any).closeAllDetails()
        await loadTransactions()
        successHandle()
    } catch (err) {
        errHandle(err as ResError)
    }
}

const successHandle = () => {
    alertDatas.value.title = "Success!"
    alertDatas.value.type = "success"
    alertDatas.value.info = "Operation Success!"
    alertDatas.value.show = true
    loading.value = false
    checkCurPageIndex()
}

const errHandle = async (e: ResError) => {
    alertDatas.value.title = "Something wrong!"
    alertDatas.value.type = "error"
    e.data.reason += ", Jumping to Home after 3 seconds..."
    alertDatas.value.info = e
    alertDatas.value.show = true
    transactions.value = []
    // await delay(3000)
    // localClear()
    // useRouter().push(Paths.home)
    loading.value = false
}

const filterFieldNames = {
    "Name": "item_name",
    "Unit Price": "item_price",
    "Amount": "item_amount",
    "Brand": "item_brand",
    "Total Price": "item_total_price",
    "Category": "category",
    "Date": "date",
}

const compareRelaNames = {
    "=": "equal",
    "!=":"not_equal",
    "prefix": "prefix",
    "suffix": "suffix",
    "contains": "contains",
    "!prefix": "not_prefix",
    "!suffix": "not_suffix",
    "!contains": "not_contains",
    ">": "greater",
    "<": "smaller",
    "≥": "greater_and_equal",
    "≤": "smaller_and_equal",
}

const keyword = ref("")
const filters = ref<string[][]>([])

const checkCurPageIndex = () => {
    if (curPage.value > pageCount()) {
        curPage.value = pageCount()
    }
}

const loadTransactions = async () => {
    loading.value = true
    var f = filters.value.map( r => 
        filterFieldNames[r[0] as keyof typeof filterFieldNames] + "," +
        compareRelaNames[r[1] as keyof typeof compareRelaNames] + "," +
        r[2]
    )
    if (keyword.value.length > 0) f = [`item_name,contains,${keyword.value}`].concat(f)
    const filterStr = f.join(";")
    try {
        totalCount.value = await BearerFetch(be.head + be.api.userspace.transactions + "/count?filter=" + filterStr) as number
        checkCurPageIndex()
        console.log(be.head +
            be.api.userspace.transactions +
            `?page=${curPage.value}&per=${numPerPage.value}&total=${pageCount()}` +
            `&sortBy=${filterFieldNames[sort.value as keyof typeof filterFieldNames]}&sortDescending=${descending.value ? 1 : 0}` +
            `&filter=${filterStr}`)
        const res = await BearerFetch(
            be.head +
            be.api.userspace.transactions +
            `?page=${curPage.value}&per=${numPerPage.value}&total=${pageCount()}` +
            `&sortBy=${filterFieldNames[sort.value as keyof typeof filterFieldNames]}&sortDescending=${descending.value ? 1 : 0}` +
            `&filter=${filterStr}`
        ) as TransactionRes[]
        loading.value = false
        checkCurPageIndex()
        transactions.value = res
    } catch (err) {
        errHandle(err as ResError)
    }
}

</script>

<template>
    <v-container fluid>
        <DashboardFilter @search="loadTransactions()" @resort="loadTransactions()" v-model:filter="filters" v-model:search="keyword" v-model:sort="sort" v-model:descending="descending" />
        <DashboardTransactionList v-if="!loading" ref="transactionList" :numPerPage="numPerPage"
            :transactions="transactions.map(a => toFormValue(a))" @submit="submit" @delete="del" />
        <v-skeleton-loader v-else color="white" :elevation="0" class="border mx-auto pa-0 fill-width" type="table"
            style="display: block; height: 460px" />
        <v-row class="text-center" no-gutters align="center" justify="center">
            <v-col class="mx-0" cols="auto" style="width: 130px;">
                <v-select hide-details rounded density="compact" label="# of per Page" variant="solo" v-model="numPerPage" @update:model-value="loadTransactions()" :items="[5, 10, 15, 20, 30, 40, 50, 75, 100, 150, 200, 300, 500, 1000]"/>
            </v-col>
            <v-col class="mx-0">
                <v-pagination class="mx-0" v-model="curPage" @update:modelValue="loadTransactions()" rounded="shaped" :length="pageCount()"/>
            </v-col>
        </v-row>
    </v-container>
</template>