<template>
    <v-parallax class="grow contents" src="https://cdn.vuetifyjs.com/images/backgrounds/vbanner.jpg">
        <v-app-bar color="black" :elevation="0">
            <Header showButton />
        </v-app-bar>
        <v-main>
            <slot />
        </v-main>
    </v-parallax>
</template>