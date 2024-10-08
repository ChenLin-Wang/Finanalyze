<script setup lang="ts">
import type { InfoGetRes } from '~/shared/backend';
import { localClear } from '~/shared/funcs';
import { globalKeys, Paths, userSpaceItems } from '~/shared/paths';

const userInfos = ref(inject(globalKeys.userInfosKey) as InfoGetRes)

const logOut = () => { localClear() }

</script>

<template>
    <v-container fluid class="text-begin pa-0 ma-0">
        <v-list>
            <v-list-item :prepend-avatar="userInfos.avatar" :subtitle="userInfos?.user?.email"
                :title="userInfos?.username">
            </v-list-item>
        </v-list>
        <v-divider></v-divider>
        <v-list :lines="false" density="default" nav>
            <v-list-item :to="item.link" v-for="(item, i) in userSpaceItems" :key="i" :value="item" color="primary">
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
    </v-container>
</template>