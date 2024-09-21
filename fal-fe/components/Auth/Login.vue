<script setup lang="ts">
import type { VForm } from 'vuetify/components';
import { Paths } from '~/shared/paths';
const props = withDefaults(defineProps<{ loading?: boolean }>(), { loading: false })
const email = ref("")
const password = ref("")
const emailRules = ref([
    (v: string) => !!v || 'Email is required',
    (v: string) => /.+@.+\..+/.test(v) || 'Email must be valid',
])
const passwordRules = ref([
    (v: string) => !!v || 'Password is required',
    (v: string) => v.length >= 6 || 'Password must be at least 6 characters',
])
const visible = ref(false)
const form = ref<VForm | null>(null)
export type UserLoginData = { email: string, password: string }
const emit = defineEmits<{ (e: "login", data: UserLoginData): void }>()
const login = async () => {
    if (form.value == undefined || !(await form.value.validate()).valid) return
    emit('login', { email: email.value, password: password.value });
}
</script>

<template>
    <v-card class="mx-auto pa-12" elevation="8" max-width="448" rounded="lg">
        <v-form ref="form" v-if="!loading">
            <div class="text-subtitle-1 text-medium-emphasis">Account</div>

            <v-text-field density="compact" placeholder="Email address" prepend-inner-icon="mdi-email-outline"
                variant="outlined" v-model="email" :rules="emailRules"></v-text-field>

            <div class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between">
                Password

                <a class="text-caption text-decoration-none text-blue" href="#" rel="noopener noreferrer"
                    target="_blank">
                    Forgot login password?</a>
            </div>

            <v-text-field :append-inner-icon="visible ? 'mdi-eye-off' : 'mdi-eye'" :type="visible ? 'text' : 'password'"
                density="compact" placeholder="Enter your password" prepend-inner-icon="mdi-lock-outline"
                variant="outlined" v-model="password" :rules="passwordRules" @click:append-inner="visible = !visible"></v-text-field>

            <v-card class="mb-12" color="surface-variant" variant="tonal">
                <v-card-text class="text-medium-emphasis text-caption">
                    Warning: After 3 consecutive failed login attempts, you account will be temporarily locked for three
                    hours. If you must login now, you can also click "Forgot login password?" below to reset the login
                    password.
                </v-card-text>
            </v-card>

            <v-btn class="mb-8" color="blue" size="large" variant="tonal" block @click="login">
                Log In
            </v-btn>

            <v-card-text class="text-center">
                <v-btn class="text-blue" @click="useRouter().push(Paths.register)">
                    Sign up now <v-icon icon="mdi-chevron-right"></v-icon>
                </v-btn>
            </v-card-text>
        </v-form>
        <v-skeleton-loader v-else color="white" elevation="0" rounded="lg"
                    class="py-0 ma-0 fill-height" type="list-item-three-line, divider, list-item-two-line, divider, list-item-three-line, divider, list-item, divider, article, chip"
                    style="display: block; " />
    </v-card>
</template>