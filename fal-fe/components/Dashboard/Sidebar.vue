<script setup lang="ts">
import type { InfoGetRes } from '~/shared/backend';
import { globalKeys, Paths } from '~/shared/paths';

const items = ref([
    {
        title: "Overview",
        link: "/dashboard",
        icon: "mdi-sprout-outline"
    }, {
        title: "Account",
        link: "/dashboard/account",
        icon: "mdi-account-circle-outline"
    }, {
        title: "Transactions",
        link: "/dashboard/transactions",
        icon: "mdi-shopping-outline"
    }, {
        title: "AI Analytic",
        link: "/dashboard/ai_analytic",
        icon: "mdi-google-analytics"
    }, {
        title: "Find",
        link: "/dashboard/find",
        icon: "mdi-tag-search-outline"
    }, {
        title: "Share",
        link: "/dashboard/share",
        icon: "mdi-share-all-outline"
    }, {
        title: "Settings",
        link: "/dashboard/settings",
        icon: "mdi-cog"
    }
])

const userInfos = ref(inject(globalKeys.userInfosKey) as InfoGetRes)

const logOut = () => {
    localStorage.clear()
    useRouter().push(Paths.home)
}

</script>

<template>
    <v-container fluid class="text-begin pa-0 ma-0">
        <v-layout>
            <v-navigation-drawer permanent style="margin-top: 64px;" class="text-black">
                <v-list>
                    <v-list-item prepend-avatar="https://cdn.vuetifyjs.com/images/john.png" :subtitle="userInfos.user.email"
                        :title="userInfos.user.username">
                    </v-list-item>
                </v-list>
                <v-divider></v-divider>
                <v-list :lines="false" density="default" nav>
                    <v-list-item :to="item.link" v-for="(item, i) in items" :key="i" :value="item" color="primary">
                        <template v-slot:prepend>
                            <v-icon :icon="item.icon"></v-icon>
                        </template>
                        <v-list-item-title v-text="item.title"></v-list-item-title>
                    </v-list-item>
                </v-list>
                <v-divider></v-divider>
                <v-list :lines="false" density="default" nav>
                    <v-list-item value="logout" color="primary" @click="logOut">
                        <template v-slot:prepend>
                            <v-icon icon="mdi-logout-variant"></v-icon>
                        </template>
                        <v-list-item-title>Log out</v-list-item-title> 
                    </v-list-item>
                </v-list>
                <v-divider></v-divider>
            </v-navigation-drawer>
        </v-layout>
    </v-container>
</template>