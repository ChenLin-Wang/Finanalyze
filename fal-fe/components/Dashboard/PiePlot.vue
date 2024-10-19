<template>
	<ClientOnly class="fill-height">
		<v-container fluid class=" fill-height">
			<Doughnut :options="/* @ts-ignore */ chartOptions" :data="chartData"/>
		</v-container>
	</ClientOnly>
</template>

<script setup lang="ts">
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
import { Doughnut } from 'vue-chartjs'
import type { CategoryRes } from '~/shared/backend';
import { Fonts } from '~/shared/fonts';
import ChartDataLabels from 'chartjs-plugin-datalabels';

ChartJS.register(ArcElement, Tooltip, Legend, ChartDataLabels)

const props = defineProps<{
	datas: CategoryRes[]
    costerColors: String[]
    counterColors: String[]
    totalCost: number
    totalCount: number
}>()

const chartData = ref({
	labels: props.datas.map(d => d.name),
	datasets: [
		{
			label: 'Expenses',
			data: props.datas.map(d => d.costWeight),
			backgroundColor: props.costerColors,
			fill: false,
			yAxisID: 'y1',
			datalabels: {
				color: "black",
				anchor: 'center',
				align: 'center',
				formatter: (value: number, context: { dataIndex: number }) => `${Math.round(value / props.totalCost * 10000) / 100}%`,
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					size: 10,
				},
			},
		}, {
			label: 'Item Counts',
			data: props.datas.map(d => d.countWeight),
			backgroundColor: props.counterColors,
			fill: false,
			yAxisID: 'y2',
			datalabels: {
				color: "black",
				anchor: 'center',
				align: 'center',
				formatter: (value: number, context: { dataIndex: number }) => `${Math.round(value / props.totalCount * 10000) / 100}%`,
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					size: 10,
				},
			},
		},
	]
})
const chartOptions = ref({
	responsive: true,
	maintainAspectRatio: false,
	plugins: {
		legend: {
			display: true,
			position: 'top',
			labels: {
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
		},
		title: {
			display: true,
			text: 'Category Pie',
			font: {
				size: 18,
				family: Fonts.Playwrite_England_SemiJoined,
				weight: 'bold'
			},
			color: 'black',
			padding: {
				top: 0,
				bottom: 0
			},
		}
	},
})
</script>