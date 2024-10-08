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

function toFormValue(value: TransactionRes): TransactionValue {
    return {
        id: value.id,
        itemName: value.itemName,
        itemAmount: value.itemAmount,
        pricePerUnit: value.pricePerUnit,
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
        itemAmount: value.itemAmount,
        pricePerUnit: value.pricePerUnit,
        location: value.location,
        brand: value.brand,
        category: value.category,
        transactionDate: value.__transactionDate
    }
}

onBeforeMount(async () => {
    await loadTransactions()
})

const loadTransactions = async () => {
    loading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.userspace.transactions) as TransactionRes[]
        successHandle()
        transactions.value = res
    } catch (err) {
        errHandle(err as ResError)
    }
}

const submit = async (transaction: TransactionValue, i: number) => {
    // loading.value = true
    try {
        const res = await BearerFetch(be.head + be.api.userspace.transactions, {
            method: "POST",
            body: transaction
        })
        successHandle()
        // await loadTransactions()
        transactions.value[i] = toFormRes(transaction);
        (transactionList.value as any).closeAllDetails()
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
        successHandle()
        transactions.value = transactions.value.filter( (_, ind) => ind !== i );
        (transactionList.value as any).closeAllDetails()
    } catch (err) {
        errHandle(err as ResError)
    }
}

const successHandle = () => {
    alertDatas.value.title = "Success!"
    alertDatas.value.type = "success"
    alertDatas.value.info = "Fetch transaction data successfully!"
    alertDatas.value.show = true
    loading.value = false
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

</script>

<template>
    <DashboardTransactionList ref="transactionList" v-if="!loading" :transactions="transactions.map(a => toFormValue(a))" @submit="submit"
        @delete="del" />
    <v-skeleton-loader v-else color="white" :elevation="0" class="border mx-auto pa-0 fill-height fill-width"
        type="image, article, image, table" style="display: block;"></v-skeleton-loader>
</template>