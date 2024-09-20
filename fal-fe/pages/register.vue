<script setup lang="ts">
import type { UserRegisData } from '~/components/Auth/Regis.vue';
import { be, type RegisPostRes, type LoginPostRes } from '~/shared/backend';
import { Paths } from '~/shared/paths';

definePageMeta({ layout: 'plain' })

const regis = async (value: UserRegisData) => {
    try {
        const res: RegisPostRes = await $fetch(be.head + be.api.auth.register, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json"
            },
            body: {
                email: value.email,
                password: value.password
            }
        })
        useRouter().push(Paths.login);
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