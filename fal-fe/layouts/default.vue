<script setup lang="ts">

const loading = ref(true)

onMounted(async () => {
    
})

</script>

<template>
    <Header />
    <div style="width: 100%; height: 64px;"></div>
    <v-container fluid class="pa-0 ma-0">
        <v-row no-gutters>
            <v-col class="pa-0 ma-0" cols="auto" style="width: 256px; min-height: calc(100vh - 64px);">
                <DashboardSidebar v-if="!loading"></DashboardSidebar>
                <v-skeleton-loader v-else color="white" :elevation="0"
                    class="border mx-auto pa-0 fill-height fill-width"
                    type="list-item-avatar-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider, list-item-two-line, divider" 
                    style="display: block;"></v-skeleton-loader>
            </v-col>
            <v-col cols="auto" style="display: flex;">
                <v-divider vertical style="height: 100%;"></v-divider>
            </v-col>
            <v-col>
                 <slot v-if="!loading" />
                 <v-skeleton-loader v-else color="white" :elevation="0"
                    class="border mx-auto pa-0 fill-height fill-width"
                    type="image, article, image, table" style="display: block;"></v-skeleton-loader>
            </v-col>
        </v-row>

    </v-container>
</template>