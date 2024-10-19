<template>
	<ClientOnly class="fill-height">
		<div id="legend-container"></div>
		<v-container fluid class="fill-height">
			<Line :options="/* @ts-ignore */ chartOptions" :data="chartData" />
		</v-container>
	</ClientOnly>
</template>

<script setup lang="ts">
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend } from 'chart.js'
import { Line } from 'vue-chartjs'
import type { TimelineRes } from '~/shared/backend';
import { Fonts } from '~/shared/fonts';
import ChartDataLabels from 'chartjs-plugin-datalabels';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, ChartDataLabels)

const props = defineProps<{
	datas: TimelineRes[]
}>()

const chartData = ref({
	labels: props.datas.map(d => d.date),
	datasets: [
		{
			label: 'Expenses',
			data: props.datas.map(d => d.costWeight),
			borderColor: '#ff6700',
			backgroundColor: '#ff6700',
			pointBackgroundColor: '#ff6700',
			pointBorderColor: '#ff6700',
			fill: false,
			yAxisID: 'y1',
			datalabels: {
				color: 'red',
				anchor: 'right',
				align: 'right',
				formatter: (value: number) => value,
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					size: 10,
				},
			},
		}, {
			label: 'Item Counts',
			data: props.datas.map(d => d.countWeight),
			borderColor: '#4361ee',
			backgroundColor: '#4361ee',
			pointBackgroundColor: '#4361ee',
			pointBorderColor: '#4361ee',
			fill: false,
			yAxisID: 'y2',
			datalabels: {
				color: 'blue',
				anchor: 'right',
				align: 'right',
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
				maxTicksLimit: 8,
				min: 0,
				max: 8,
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
				color: "red",
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			ticks: {
				color: 'red',
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
				color: "blue",
				font: {
					family: Fonts.Playwrite_England_SemiJoined,
					weight: 'bold'
				},
			},
			ticks: {
				color: 'blue',
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
			text: 'Timeline Based Frequencies',
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