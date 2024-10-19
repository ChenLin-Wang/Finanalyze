<script setup lang="ts">
import type { SummaryRes } from '~/shared/backend';

const props = defineProps<{
    summary: SummaryRes
}>()

// title, color, value1, value2
const layout = [
    [
        ["Total Expenses:", "orange", "\u20B1" + props.summary.totalCost.toString()],
        ["Total Counts:", "blue", props.summary.totalCount.toString() + " items"]
    ], [
        ["Current Month:", "yellow", "\u20B1" + props.summary.currentMonthCost.toString(), props.summary.currentMonthCount.toString() + " items"],
        ["Last Month:", "green", "\u20B1" + props.summary.lastMonthCost.toString(), props.summary.lastMonthCount.toString() + " items"]
    ]
]
</script>

<template>
    <v-container fluid class="fill-height pa-2" style="overflow: scroll;">
        <v-row no-gutters class="fill-height">
            <v-col v-for="group in layout" cols="12">
                <v-row no-gutters class="fill-height">
                    <v-col v-for="item in group" cols="6" class="pa-2">
                        <v-card :color="item[1] as string" class="fill-height d-flex flex-column" elevation="8">
                            <v-card-title class="title flex-shrink-0"><strong>{{ item[0] }}</strong></v-card-title>
                            <v-row no-gutters class="text-end flex-grow-1 ma-2" align="end" justify="end">
                                <v-col cols="12" class="pa-2">
                                    <h2 class="content">{{ item[2] }}</h2>
                                    <h2 class="content" v-if="item[3]">{{ item[3] }}</h2>
                                </v-col>
                            </v-row>
                        </v-card>
                    </v-col>
                </v-row>
            </v-col>
        </v-row>
    </v-container>
</template>

<style lang="css" scoped>

.title {
    font-family: var(--Playwrite-England-SemiJoined);
}

.content {
    font-family: var(--Playwrite-England-SemiJoined);
}

</style>