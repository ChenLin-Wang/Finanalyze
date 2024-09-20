<script setup lang="ts">
import type { UserLoginData } from '~/components/Auth/Login.vue';
import { be, type LoginPostRes } from '~/shared/backend';
import { Paths } from '~/shared/paths';

definePageMeta({
    layout: 'plain'
})

const login = async (value: UserLoginData) => {
    console.log(btoa(`${value.email}:${value.password}`))
    try {
        const res: LoginPostRes = await $fetch(be.head + be.api.auth.login, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Basic " + btoa(`${value.email}:${value.password}`)
            }
        })
        localStorage.setItem(be.tokenKey, res.token)
        useRouter().push(Paths.dashboard)
    } catch (err) {
        console.error('Error: ', err)
    }
}

</script>

<template>
    <v-container fluid class="ma-0 pa-0">
        <v-row class="ma-0 pa-0" style="min-height: 100vh;" align="center" justify="center"> 
            <v-col>
                <AuthLogin class="ma-5" @login="login"></AuthLogin>
            </v-col>
        </v-row>
    </v-container>
</template>