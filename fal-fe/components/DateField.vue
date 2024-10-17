<template>
    <v-text-field readonly
        id="dateField"
        v-model="dateStr"
        :label="label"
        :variant="variant"
        :density="density"
        :rules="rs"
        :rounded="rounded"
        @click="menu = !readonly"
    >
        <v-menu
            v-if="!readonly"
            activator="#dateField"
            v-model="menu"
            location="bottom"
            :close-on-content-click="false"
            transition="scale-transition">
            <v-date-picker class="rounded-xl" :min="min" :max="max" color="primary" v-model="selectedDate" @input="menu = false"></v-date-picker>
        </v-menu>
    </v-text-field>
</template>

<script setup lang="ts">
import { dateFormat } from '../shared/dateFunctions';
const date = defineModel<Date>("date")
const dateStr = defineModel<string>("dateStr")
const props = withDefaults(defineProps<{
    rounded?: boolean,
    density?: null | 'default' | 'comfortable' | 'compact',
    label: string,
    min?: Date,
    max?: Date,
    variant?: "filled" | "underlined" | "outlined" | "plain" | "solo" | "solo-inverted" | "solo-filled",
    rules?: ((v: Date) => true | string)[],
    readonly?: boolean
}>(), {
    rounded: false,
    density: 'default',
    label: "",
    variant: "underlined",
    readonly: false
})
// @ts-ignore
const rs = ref<ValidationRule$1[]>([
    (v: string) => {
        if (!props.rules) return true
        else {
            for (let r of props.rules ) {
                const res = r(date.value as Date)
                if (res !== true) return res
            }
            return true
        }
    }
])
const menu = ref(false);
const selectedDate = ref<Date|null>(null);

onMounted(() => {
    if (dateStr.value && dateStr.value !== "") {
        date.value = new Date(dateStr.value)
    } else if (date.value) {
        dateStr.value = dateFormat(date.value, "YYYY-MM-DD")
    }
    selectedDate.value = date.value as Date
})

watch(selectedDate, (newDate) => { 
    if (newDate) { 
        date.value = newDate
        dateStr.value = dateFormat(newDate, "YYYY-MM-DD")
        menu.value = false
    } 
});

</script>
  