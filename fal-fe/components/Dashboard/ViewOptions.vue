<script setup lang="ts">

const selectors = {
    "Daily": 
        ["Start Date"],
    "Monthly": 
        ["Start Date"],
    "Yearly": 
        ["Start Date"]
}

export type ViewOption = {
    by: keyof typeof selectors,
    startDate?: string,
    duration?: number
}

const viewOption = defineModel<ViewOption>() as Ref<ViewOption>
const emit = defineEmits<{ (e: "viewOptionChanged"): void }>()
const changed = () => { emit("viewOptionChanged") }

</script>

<template>
    <v-row no-gutters>
        <v-col cols="3" class="px-3">
            <v-select v-model="viewOption.by" variant="solo" density="compact" :items="Object.keys(selectors)" label="View By" hide-details/>
        </v-col>
        <v-divider vertical />
        <v-col cols="3" class="px-3">
            <DateField v-model:dateStr="viewOption.startDate" variant="solo" density="compact" :label="selectors[viewOption.by][0] as string" hide-details/>
        </v-col>
        <v-divider vertical />
        <v-col cols="3" class="px-3">
            <v-text-field v-model="viewOption.duration" variant="solo" density="compact" label="duration" type="number" hide-details/>
        </v-col>
        <v-divider vertical />
        <v-col cols="3" class="px-3">
            <v-btn rounded variant="elevated" @click="changed">Refresh</v-btn>
        </v-col>
    </v-row>
</template>