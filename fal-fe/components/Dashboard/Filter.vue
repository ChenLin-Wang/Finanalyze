<script setup lang="ts">
import { CategoryIcons } from '~/shared/parameters';
import { numValidate, requireValidate } from '~/shared/validations';
import DateField from '../DateField.vue';

const emit = defineEmits<{
    (e: "search"): void,
    (e: "resort"): void
}>()

const props = withDefaults(defineProps<{
    withUsers: boolean
}>(), {
    withUsers: false
})

const filter = defineModel<string[][]>("filter")
const search = defineModel<string>("search")
const sort = defineModel<string>("sort")
const descending = defineModel<boolean>("descending")
var fields = {
    "Name": 
        [["=", "!=", "prefix", "suffix", "contains", "!prefix", "!suffix", "!contains"], "item_name", "string"],
    "Brand": 
        [["=", "!=", "prefix", "suffix", "contains", "!prefix", "!suffix", "!contains"], "item_brand", "string"],
    "Unit Price": 
        [["=", "!=", ">", "<", "≥", "≤"], "item_price", "number"],
    "Amount": 
        [["=", "!=", ">", "<", "≥", "≤"], "item_amount", "number"],
    "Total Price": 
        [["=", "!=", ">", "<", "≥", "≤"], "item_total_price", "number"],
    "Category": 
        [["=", "!="], "category", "selector", Object.keys(CategoryIcons).sort()],
    "Date": 
        [["=", "!=", ">", "<", "≥", "≤"], "date", "date"]
}

if (props.withUsers) {
    /* @ts-ignore */
    fields["User Name"] = [["=", "!=", "prefix", "suffix", "contains", "!prefix", "!suffix", "!contains"], "username", "string"]
    /* @ts-ignore */
    fields["Email"] = [["=", "!=", "prefix", "suffix", "contains", "!prefix", "!suffix", "!contains"], "email", "string"]
}

const fieldChange = (value: string, i: number) => {
    if (!filter.value) return
    filter.value[i][1] = fields[value as keyof typeof fields][0][0]
    const t = fields[value as keyof typeof fields][2]
    console.log(t)
    filter.value[i][2] = t === "string" ? "" : 
                            t === "number" ? "0" : 
                            t === "selector" ? fields[value as keyof typeof fields][3][0] :
                            (new Date()).toISOString()
}

const addField = () => {
    if (!filter.value) return
    filter.value?.push(["Name", "=", ""])
}

const removeField = (i: number) => {
    if (!filter.value) return
    filter.value = filter.value.filter( (_, ind) => ind !== i )
}

</script>

<template>
    <v-row no-gutters align="center" justify="center">
        <v-col>
            <v-text-field v-on:keyup.enter="emit('search')" density="comfortable" v-model="search" label="Search" prepend-inner-icon="mdi-magnify" variant="outlined" hide-details/>
        </v-col>
        <v-col cols="auto" style="width: 140px;">
            <v-select @update:model-value="emit('resort')" hide-details density="comfortable" variant="outlined" label="Sort By" v-model="sort" :items="Object.keys(fields).sort()"/>
        </v-col>
        <v-col cols="auto">
            <v-checkbox @update:model-value="emit('resort')" color="blue" hide-details density="comfortable" variant="outlined" label="Descending" v-model="descending"/>
        </v-col>
    </v-row>
    <v-row class="pa-3" no-gutters>
        <v-card style="max-height:300px; width:100%; overflow: scroll;">
            <v-row v-for="(rule, i) in filter" no-gutters align="center" justify="center">
                <v-col cols="3">
                    <v-select 
                        label="Field" 
                        v-model="rule[0]"
                        @update:model-value="v => fieldChange(v, i)" 
                        :items="Object.keys(fields).sort()"
                        density="compact"
                        hide-details 
                        single-line
                    />
                </v-col>
                <v-divider vertical/>
                <v-col cols="3">
                    <v-select 
                        label="Compare" 
                        v-model="rule[1]" 
                        :items="fields[rule[0] as keyof typeof fields][0] as string[]"
                        density="compact"
                        hide-details 
                        single-line
                    />
                </v-col>
                <v-divider vertical/>
                <v-col>
                    <v-select
                        v-if="fields[rule[0] as keyof typeof fields][2] === 'selector'" 
                        label="Value" v-model="rule[2]" 
                        :items="fields[rule[0] as keyof typeof fields][3] as string[]"
                        density="compact"
                        hide-details 
                        single-line
                    />
                    <DateField 
                        v-else-if="fields[rule[0] as keyof typeof fields][2] === 'date'" 
                        label="Value" 
                        v-model:date-str="rule[2]"
                        density="compact"
                        variant="filled"
                        hide-details 
                        single-line
                    />
                    <v-text-field 
                        v-else 
                        label="Value"
                        :type="fields[rule[0] as keyof typeof fields][2] as string"
                        v-model="rule[2]"
                        density="compact"
                        hide-details 
                        single-line
                    />
                </v-col>
                <v-divider vertical/>
                <v-col cols="auto">
                    <v-btn @click="removeField(i)" density="compact" color="red" icon="mdi-delete" variant="text"/>
                </v-col>
            </v-row>
        </v-card>
        <v-row no-gutters>
            <v-btn @click="addField" class="bg-blue" style="width: 100%;">Add Filter Condition</v-btn>
        </v-row>
    </v-row>
</template>