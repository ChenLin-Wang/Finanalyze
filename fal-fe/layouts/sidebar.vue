<template>
    <Header />
    <div style="width: 100%; height: 64px;"></div>
    <v-container fluid class="pa-0 ma-0">
        <v-row no-gutters>
            <v-col cols="auto" style="width: 200px; min-height: calc(100vh - 64px);">
                <slot name="sidebar"/>
            </v-col>
            <v-col cols="auto" style="display: flex;">
                <v-divider vertical style="height: 100%;"></v-divider>
            </v-col>
            <v-col>
                <slot />
            </v-col>
        </v-row>
    </v-container>
</template>