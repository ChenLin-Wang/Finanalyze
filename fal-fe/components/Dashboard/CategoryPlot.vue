<template>
	<ClientOnly class="fill-height">
		<v-container fluid class="fill-height">
			<Bar :options="/* @ts-ignore */ chartOptions" :data="chartData"/>
		</v-container>
	</ClientOnly>
</template>

<script setup lang="ts">
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
import { Bar } from 'vue-chartjs'
import type { CategoryRes } from '~/shared/backend';
import { Fonts } from '~/shared/fonts';
import ChartDataLabels from 'chartjs-plugin-datalabels';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend, ChartDataLabels)

const props = defineProps<{
	datas: CategoryRes[]
    costerColors: String[]
    counterColors: String[]
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
				anchor: 'end',
				align: 'top',
				formatter: (value: number) => value,
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
				anchor: 'end',
				align: 'top',
				formatter: (value: number) => value,
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
	scales: {
		x: {
			beginAtZero: true,
			ticks: {
				maxRotation: 45,
				minRotation: 0,
				maxTicksLimit: 20,
				min: 0,
				max: 20,
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			grid: {
				color: '#bfdbf7',
				lineWidth: 1,
			},
			border: {
				dash: [10, 10]
			}
		},
		y1: {
			type: 'linear',
			position: 'left',
			beginAtZero: true,
			title: {
				display: true,
				text: 'Expense(\u20B1)', // Y 轴标签文本
				color: "purple",
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			ticks: {
				color: 'purple',
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
				callback: function (value: number) {
					if (value >= 1000) {
						return (value / 1000).toFixed(1) + 'k';
					}
					return value; // 返回小于 1000 的值
				},
			},
			grid: {
				color: '#ffafcc',
				lineWidth: 1,
			},
			border: {
				dash: [5, 5]
			}
		},
		y2: {
			type: 'linear',
			position: 'right',
			beginAtZero: true,
			title: {
				display: true,
				text: 'Count(Items)', // Y 轴标签文本
				color: "orange",
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			ticks: {
				color: 'orange',
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			grid: {
				color: '#a2d2ff', // 右侧Y轴网格线颜色
				lineWidth: 1, // 右侧Y轴网格线宽度
				drawOnChartArea: true, // 在图表区域绘制网格
			},
			border: {
				dash: [2, 2]
			}
		},
	},
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
			text: 'Category Based Frequencies',
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