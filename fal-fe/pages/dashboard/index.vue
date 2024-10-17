<script setup lang="ts">
import { globalKeys } from '~/shared/paths';


const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)
barTitle.value = "Welcome"

</script>

<template>
    <v-container fluid>
        <p>this is the overview</p>
    </v-container>
</template>