<script setup lang="ts">
import type { UserLoginData } from '~/components/Auth/Login.vue';
import { be, type LoginPostRes, type ResError } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { Paths } from '~/shared/paths';

definePageMeta({ layout: 'plain' })

const info = ref<ResError | string | null>(null)
const alertType = ref<"error" | "success" | "info" | "warning">("error")
const alertTitle = ref<string>("Login Failed")
const loading = ref(false)
const showAlert = ref(false)

const login = async (value: UserLoginData) => {
    loading.value = true
    try {
        const res: LoginPostRes = await $fetch(be.head + be.api.auth.login, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "Authorization": "Basic " + btoa(`${value.email}:${value.password}`)
            }
        })
        alertTitle.value = "Login Success!"
        alertType.value = "success"
        info.value = "Jumping to Dashboard..."
        showAlert.value = true
        localStorage.setItem(be.tokenKey, res.token)
        useRouter().push(Paths.dashboard)
    } catch (error) {
        alertTitle.value = "Login Failed"
        alertType.value = "error"
        info.value = error as ResError
        showAlert.value = true
    } finally {
        loading.value = false
    }
}
</script>

<template>
    <v-container fluid class="ma-0 pa-0">
        <Alert :type="alertType" :title="alertTitle" :info="info" v-model:show="showAlert" :timeout="3000"/>
        <v-row class="ma-0 pa-0" style="min-height: 100vh;" align="center" justify="center">
            <v-col>
                <AuthLogin class="ma-5" :loading="loading" @login="login" />
            </v-col>
        </v-row>
    </v-container>
</template>