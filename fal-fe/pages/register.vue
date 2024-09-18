<script setup lang="ts">
import type { UserRegisData } from '~/components/Auth/Regis.vue';
import { be_api, be_paras } from '~/shared/be_conf';

definePageMeta({ layout: 'plain' })

const regis = async (value: UserRegisData) => {
    try {
        const res = await $fetch(be_paras.head + be_api.auth.register, {
            method: 'POST',
            body: {
                user_name: value.email,
                password: value.password
            }
        })
    } catch (err) {
        console.error('Error: ', err)
    }
}
</script>
<template>
    <v-container fluid class="ma-0 pa-0">
        <v-row class="ma-0 pa-0" style="min-height: 100vh;" align="center" justify="center">
            <v-col>
                <AuthRegis @submit="regis" class="ma-5"></AuthRegis>
            </v-col>
        </v-row>
    </v-container>
</template>