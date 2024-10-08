<script setup lang="ts">
import type { VForm } from 'vuetify/components';
import { deepCopy, deepEqual } from '~/shared/funcs';
import { CategoryIcons } from '~/shared/TransactionCategories';
import { numValidate, requireValidate } from '~/shared/validations';

const emit = defineEmits<{ 
    (e: "submit", transaction: TransactionValue, i: number): void,
    (e: "delete", transaction: TransactionValue, i: number): void
}>()

export type TransactionValue = {
    id: string
    itemName: string
    itemAmount: number
    pricePerUnit: number
    location: string
    brand?: string
    category: string
    __transactionDate: string
}

const props = defineProps<{
    transaction: TransactionValue,
    i: number
}>()

const form = ref<VForm | null>(null);
const values = ref<TransactionValue>(deepCopy(props.transaction))

const submit = async () => {
    if (form.value == undefined) return;
    const { valid } = await form.value?.validate()
    if (valid) {
        var res = deepCopy(values.value)
        emit('submit', res, props.i);
    }
};

const del = async () => {
    if (form.value == undefined) return;
    const { valid } = await form.value?.validate()
    if (valid) {
        var res = deepCopy(values.value)
        emit('delete', res, props.i);
    }
}

const titles: string[] = []

// [Label, Required?, Variable Name, Cols, Type, Disable?, Validation]
const hintGroups = [
    [
        ["Name", true, "itemName", "6", "string", false, []],
        ["Brand", false, "brand", "6", "string", false, []],
    ],
    [
        ["Amount", true, "itemAmount", "4", "number", false, [numValidate(0, "Amount", false, false)]],
        ["Unit Price(\u20B1)", true, "pricePerUnit", "8", "number", false, [numValidate(0, "Amount", false, false)]],
    ],
    [["Category", true, "category", "12", "selector", false, [], Object.keys(CategoryIcons)],],
    [["Transaction Date", true, "__transactionDate", "12", "date", false, [], "transactionDate", []],],
]
</script>

<template>
    <v-container fluid>
        <v-form @submit.prevent="submit" ref="form">
            <div class="my-0" v-for="(indexes, j) in [[0, 4]]" :key="j">
                <h4 class="py-0 mt-0 mb-2">{{ titles[j] }}</h4>
                <v-row class="my-0 mx-1" v-for="(hints, i) in hintGroups.slice(indexes[0], indexes[1])" :key="i">
                    <v-col class="my-0 pt-0 pa-0" v-for="(hint, index) in hints" :key="index" :cols="<string>hint[3]">
                        <v-select v-if="<string>hint[4] === 'selector'" :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model="<any>values[<keyof TransactionValue>hint[2]]" :items="hint[7] as Array<string>"
                            :type="typeof values[<keyof TransactionValue>hint[2]]" :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])"
                            density="comfortable">
                        </v-select>
                        <DateField v-else-if="<string>hint[4] === 'date'"
                            :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model:dateStr="<string>values[<keyof FormValue>hint[2]]"
                            v-model:date="<Date>values[<keyof FormValue>hint[7]]" :disabled="<boolean>hint[5]"
                            :min="(<number[]>hint[8])[0] ? (new Date(Date.parse(new Date().toString()) + (<number[]>hint[8])[0] * 1000)) : undefined"
                            :max="(<number[]>hint[8])[1] ? (new Date(Date.parse(new Date().toString()) + (<number[]>hint[8])[1] * 1000)) : undefined"
                            variant="filled" :rules=" /* @ts-ignore */hint[6]" density="comfortable">
                        </DateField>
                        <v-text-field v-else-if="<string>hint[4] === 'string'"
                            :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model="values[<keyof TransactionValue>hint[2]]" type="string" :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])"
                            density="comfortable">
                        </v-text-field>
                        <v-text-field v-else-if="<string>hint[4] === 'number'"
                            :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model.number="values[<keyof TransactionValue>hint[2]]" type="number"
                            :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])"
                            density="comfortable">
                        </v-text-field>
                    </v-col>
                </v-row>
            </div>
            <v-row class="my-1 mx-0" no-gutters>
                <v-col class="px-1" cols="6">
                    <v-btn class="text-none" :disabled="deepEqual(values, transaction, ['transactionDate'])" color="white" width="100%"
                    @click="submit">Submit</v-btn>
                </v-col>
                <v-col class="px-1" cols="6">
                    <v-btn class="text-none" color="red" width="100%"
                    @click="del">Delete</v-btn>
                </v-col>
            </v-row>
        </v-form>
    </v-container>
</template>
