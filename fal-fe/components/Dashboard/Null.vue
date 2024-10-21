<script setup lang="ts">

const props = withDefaults(defineProps<{
    label?: string
}>(), {
    label: "Data"
})

</script>

<template>
    <v-container class="fill-height">
        <v-row class="fill-height" no-gutters align="center" justify="center">
            <v-col>
                <h3 class="text-grey text-center"><strong>No {{ label }}</strong></h3>
            </v-col>
        </v-row>
    </v-container>
</template>