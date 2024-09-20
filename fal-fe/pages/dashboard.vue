<script setup lang="ts">
definePageMeta({
    layout: false
})
</script>

<template>
    <NuxtLayout name="sidebar">
        <template #sidebar>
            <DashboardSidebar></DashboardSidebar>
        </template>

        <template #default>
            <DashboardContent></DashboardContent>
        </template>
    </NuxtLayout>
</template>