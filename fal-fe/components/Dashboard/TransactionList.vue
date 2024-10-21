<script setup lang="ts">

import { CategoryIcons } from '~/shared/parameters';
import { deepCopy, numberArray } from '~/shared/funcs';
import { DateToShortStr } from '~/shared/dateFunctions';
import type { TransactionValue } from './TransactionConvertor';
import { useDisplay } from 'vuetify';

const props = withDefaults(defineProps<{
    transactions: TransactionValue[]
    numPerPage: number
    deletable: boolean
}>(), {
    deletable: true
})

const emit = defineEmits<{
    (e: "submit", transaction: TransactionValue, i: number): void,
    (e: "delete", transaction: TransactionValue, i: number): void
}>()

const showDetails = ref(numberArray(0, props.numPerPage - 1).map(a => false))

const submit = (transaction: TransactionValue, i: number) => { emit("submit", dataHandler(transaction), i) }
const del = (transaction: TransactionValue, i: number) => emit("delete", dataHandler(transaction), i)

const dataHandler = (transaction: TransactionValue): TransactionValue => {
    var vals = deepCopy(transaction)
    vals.__transactionDate = DateToShortStr(new Date(vals.__transactionDate))
    return vals
}

const closeAllDetails = () => { showDetails.value = numberArray(0, props.numPerPage - 1).map(a => false) }
const showAndHide = (i: number) => {
    const old = showDetails.value[i];
    closeAllDetails();
    showDetails.value[i] = !old
}

defineExpose({ closeAllDetails })

const isSmallScreen = () => {
    if (process.server) return false
    return useDisplay().width.value < 600
}

</script>

<template>
    <v-list class="ma-0 pa-0" lines="two" density="comfortable" style="overflow: hidden">
        <v-divider />
        <div v-for="(transaction, i) in transactions" :key="i">
            <v-row nogutters align="center" justify="center">
                <v-col>
                    <v-list-item @click="showAndHide(i)"
                        :subtitle="`${transaction.__transactionDate}  ${transaction.category}`"
                        :title="transaction.brand ? `${transaction.itemName} (${transaction.brand})` : transaction.itemName">
                        <template v-slot:prepend>
                            <v-avatar class="flex-shrink-0" :color="CategoryIcons[transaction.category as keyof typeof CategoryIcons].color">
                                <v-icon>{{ CategoryIcons[transaction.category as keyof typeof CategoryIcons].icon }}</v-icon>
                            </v-avatar>
                        </template>
                        <template v-slot:append>
                            <h4 v-if="!isSmallScreen()">{{ `${transaction.itemAmount} &times;&#8369;${transaction.pricePerUnit} =&nbsp;` }}</h4>
                            <h4 class="text-red">{{ `&#8369;${Math.round(transaction.itemAmount * transaction.pricePerUnit * 100) / 100}` }}</h4>
                            <v-divider v-if="!deletable" vertical class="mx-3"/>
                            <div v-if="!deletable && !isSmallScreen()" class="text-end mr-3">
                                <v-row no-gutters class="pa-0 ma-0">
                                    <v-col class="pa-0 ma-0">
                                        <h5>{{ transaction.user?.username }}</h5>
                                        <h5>{{ transaction.user?.email }}</h5>
                                    </v-col>
                                </v-row>
                            </div>
                            <v-avatar v-if="!deletable" style="max-width: 300px;">
                                <v-img :alt="transaction.user?.username" :src="transaction.user?.avatar"></v-img>
                            </v-avatar>
                        </template>
                    </v-list-item>
                </v-col>
                <v-col v-if="deletable" cols="auto" class="ml-0 pl-0">
                    <v-btn :color="CategoryIcons[transaction.category as keyof typeof CategoryIcons].color"
                        @click="del(transaction, i)" icon="mdi-delete" variant="text"></v-btn>
                </v-col>
            </v-row>
            <v-divider />
            <dashboard-transaction-form :editable="deletable" v-if="showDetails[i]" @submit="submit" @delete="del"
                :transaction="transaction" :i="i" />
            <v-divider v-if="showDetails[i]" />
        </div>
    </v-list>
</template>