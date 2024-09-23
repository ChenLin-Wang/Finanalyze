<script setup lang="ts">
import type { UserRegisData } from '~/components/Auth/Regis.vue';
import { be, type RegisPostRes, type LoginPostRes, type ResError } from '~/shared/backend';
import { delay, localClear } from '~/shared/funcs';
import { Paths } from '~/shared/paths';

definePageMeta({ layout: 'plain' })

const info = ref<ResError | string | null>(null)
const alertType = ref<"error" | "success" | "info" | "warning">("error")
const alertTitle = ref<string>("Register Failed")
const loading = ref(false)

const regis = async (value: UserRegisData) => {
    loading.value = true
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
        alertTitle.value = "Register Success!"
        alertType.value = "success"
        info.value = "Jumping to Login..."
        // await delay(3000)
        useRouter().push(Paths.login);
    } catch (error) {
        alertTitle.value = "Register Failed"
        alertType.value = "error"
        info.value = error as ResError
        localClear()
    } finally {
        loading.value = false
    }
}
</script>
<template>
    <v-container fluid class="ma-0 pa-0">
        <Alert :type="alertType" :title="alertTitle" v-model:info="info" />
        <v-row class="ma-0 pa-0" style="min-height: 100vh;" align="center" justify="center">
            <v-col>
                <AuthRegis @submit="regis" :loading="loading" class="ma-5"></AuthRegis>
            </v-col>
        </v-row>
    </v-container>
</template>