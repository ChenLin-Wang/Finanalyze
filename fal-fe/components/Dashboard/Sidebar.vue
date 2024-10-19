<script setup lang="ts">
import type { InfoGetRes } from '~/shared/backend';
import { localClear } from '~/shared/funcs';
import { globalKeys, Paths, userSpaceItems } from '~/shared/paths';

const userInfos = ref(inject(globalKeys.userInfosKey) as InfoGetRes)

const logOut = () => { localClear() }

</script>

<template>
    <v-container fluid class="text-begin d-flex flex-column pa-0 ma-0 fill-height">
        <div class="flex-shrink-0">
            <v-list>
                <v-list-item :prepend-avatar="userInfos.avatar" :subtitle="userInfos?.user?.email"
                    :title="userInfos?.username">
                </v-list-item>
            </v-list>
            <v-divider />
        </div>
        <div class="flex-grow-1" style="overflow: scroll; height: 0px; width: 100%">
            <v-list :lines="false" density="default" nav>
                <v-list-item :to="item.link" v-for="(item, i) in userSpaceItems" :key="i" :value="item" color="primary">
                    <template v-slot:prepend>
                        <v-icon :icon="item.icon"></v-icon>
                    </template>
                    <v-list-item-title v-text="item.title"></v-list-item-title>
                </v-list-item>
            </v-list>
            <v-divider />
        </div>
        <div class="flex-shrink-0" style=" width: 100%;">
            <v-divider />
            <div class="px-3" style="padding-top: 14px; padding-bottom: 14px;">
                <v-btn rounded variant="elevated" style="width: 100%;" @click="logOut">Log out</v-btn>
            </div>
        </div>
    </v-container>
</template>