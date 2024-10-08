<!-- export type TransactionRes = {
    id: string
    itemName: string
    itemAmount: number
    pricePerUnit: number
    location: string
    brand?: string
    category: string
    transactionDate: string
} -->

<script setup lang="ts">
import { CategoryIcons } from '~/shared/TransactionCategories';
import type { TransactionValue } from './TransactionForm.vue';
import { deepCopy, numberArray } from '~/shared/funcs';
import { DateToShortStr } from '~/shared/dateFunctions';

const numPerPage = 200

const props = defineProps<{
    transactions: TransactionValue[]
}>()

const emit = defineEmits<{
    (e: "submit", transaction: TransactionValue, i: number): void,
    (e: "delete", transaction: TransactionValue, i: number): void
}>()

const showDetails = ref(numberArray(0, numPerPage - 1).map(a => false))

const submit = (transaction: TransactionValue, i: number) => { emit("submit", dataHandler(transaction), i) }
const del = (transaction: TransactionValue, i: number) => emit("delete", dataHandler(transaction), i)

const dataHandler = (transaction: TransactionValue): TransactionValue => {
    var vals = deepCopy(transaction)
    vals.__transactionDate = DateToShortStr(new Date(vals.__transactionDate))
    return vals
}

const closeAllDetails = () => { showDetails.value = numberArray(0, numPerPage - 1).map(a => false) }
const showAndHide = (i: number) => {
    const old = showDetails.value[i]; 
    closeAllDetails(); 
    showDetails.value[i] = !old
}

defineExpose({ closeAllDetails })

</script>

<template>
    <v-list class="ma-0 pa-0" lines="two" density="comfortable">
        <v-divider />
        <div v-for="(transaction, i) in transactions" :key="i">
            <v-list-item @click="showAndHide(i)" :subtitle="`${transaction.__transactionDate}  ${transaction.category}`"
                :title="transaction.brand ? `${transaction.itemName} (${transaction.brand})` : transaction.itemName">
                <template v-slot:prepend>
                    <v-avatar :color="CategoryIcons[transaction.category as keyof typeof CategoryIcons].color">
                        <v-icon>{{ CategoryIcons[transaction.category as keyof typeof CategoryIcons].icon }}</v-icon>
                    </v-avatar>
                </template>
                <template v-slot:append>
                    <h4>{{ `${transaction.itemAmount} &times; &#8369;${transaction.pricePerUnit} = ` }}</h4>
                    <h4 class="text-red">{{ `&#8369;${Math.round(transaction.itemAmount * transaction.pricePerUnit *
                        100) / 100}` }}</h4>
                    <v-btn :color="CategoryIcons[transaction.category as keyof typeof CategoryIcons].color"
                        @click="del(transaction, i)" icon="mdi-delete" variant="text"></v-btn>
                </template>
            </v-list-item>
            <v-divider />
            <dashboard-transaction-form v-if="showDetails[i]" @submit="submit" @delete="del" :transaction="transaction" :i="i" />
            <v-divider v-if="showDetails[i]" />
        </div>
    </v-list>
</template>