<script setup lang="ts">
import { toFormValue, type TransactionValue } from '~/components/Dashboard/TransactionConvertor';
import type { AlertDatas, LoadingStatus } from '~/layouts/default.vue';
import { be, BearerFetch, type AllTransRes, type ResError, type TransactionRes } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { CompareRelaNames, FilterFieldNames } from '~/shared/parameters';
import { globalKeys, Paths } from '~/shared/paths';

const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)
barTitle.value = "Find"

const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
const transactions = ref<TransactionValue[]>([])
const loading = ref(true)
const transactionList = ref(null)
const totalCount = ref(0)
const numPerPage = ref(15)
const curPage = ref(1)
const pageCount = () => Math.ceil(totalCount.value / numPerPage.value)

const sort = ref("Email")
const descending = ref(true)

onBeforeMount(async () => await loadTransactions())

const errHandle = async (e: ResError) => {
    alertDatas.value.title = "Something wrong!"
    alertDatas.value.type = "error"
    e.data.reason += ", Jumping to Home after 3 seconds..."
    alertDatas.value.info = e
    alertDatas.value.show = true
    transactions.value = []
    await delay(3000)
    localClear()
    useRouter().push(Paths.home)
    loading.value = false
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
    var f = filters.value.map(r =>
        FilterFieldNames[r[0] as keyof typeof FilterFieldNames] + "," +
        CompareRelaNames[r[1] as keyof typeof CompareRelaNames] + "," +
        r[2]
    )
    if (keyword.value.length > 0) f = [`item_name,contains,${keyword.value}`].concat(f)
    const filterStr = f.join(";")
    try {
        totalCount.value = await BearerFetch(be.head + be.api.userspace.transactions.all + "/count?filter=" + filterStr) as number
        checkCurPageIndex()
        const res = await BearerFetch(
            be.head +
            be.api.userspace.transactions.all +
            `?page=${curPage.value}&per=${numPerPage.value}&total=${pageCount()}` +
            `&sortBy=${FilterFieldNames[sort.value as keyof typeof FilterFieldNames]}&sortDescending=${descending.value ? 1 : 0}` +
            `&filter=${filterStr}`
        ) as AllTransRes[]
        loading.value = false
        checkCurPageIndex()
        const allTrans = res.map ( r => {
            let s = toFormValue(r.transaction)
            s.user = r.user
            return s
        })
        transactions.value = allTrans
    } catch (err) {
        errHandle(err as ResError)
    }
}

</script>

<template>
    <v-container fluid class="d-flex flex-column pa-0" style="height: 100%">
        <div class="mt-0 pt-3 flex-grow-1 pa-3" style="overflow: scroll;">
            <DashboardFilter :with-users="true" @search="loadTransactions()" @resort="loadTransactions()"
                v-model:filter="filters" v-model:search="keyword" v-model:sort="sort" v-model:descending="descending" />
            <DashboardTransactionList v-if="!loading"
                ref="transactionList" :numPerPage="numPerPage" :transactions="transactions" :deletable="false" />
            <v-skeleton-loader v-else color="white" :elevation="0" class="border mx-auto pa-0 fill-width" type="table"
            style="display: block; height: 446px" />
        </div>
        <v-divider />
        <v-row class="text-center flex-shrink-0 flex-grow-0 px-3" style="height:64px" no-gutters align="center"
            justify="center">
            <v-col class="mx-0" cols="auto" style="width: 130px;">
                <v-select hide-details rounded density="compact" label="# of per Page" variant="solo"
                    v-model="numPerPage" @update:model-value="loadTransactions()"
                    :items="[5, 10, 15, 20, 30, 40, 50, 75, 100, 150, 200, 300, 500, 1000]" />
            </v-col>
            <v-col class="mx-0">
                <v-pagination class="mx-0" v-model="curPage" @update:modelValue="loadTransactions()" rounded="shaped"
                    :length="pageCount()" />
            </v-col>
        </v-row>
    </v-container>
</template>