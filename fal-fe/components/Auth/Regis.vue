<template>
    <v-card class="mx-auto pa-12 pb-8" elevation="8" max-width="448" rounded="lg">
        <v-form ref="form">
            <div class="text-subtitle-1 text-medium-emphasis">Create an Account</div>

            <v-text-field density="compact" placeholder="Email address" prepend-inner-icon="mdi-email-outline"
                variant="outlined" v-model="email" :rules="emailRules"></v-text-field>

            <div class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between">
                Password
            </div>

            <v-text-field :append-inner-icon="passwordVisible ? 'mdi-eye-off' : 'mdi-eye'"
                :type="passwordVisible ? 'text' : 'password'" density="compact" placeholder="Enter your password"
                prepend-inner-icon="mdi-lock-outline" variant="outlined" v-model="password"
                @click:append-inner="passwordVisible = !passwordVisible" :rules="passwordRules"></v-text-field>

            <v-text-field :append-inner-icon="confirmPasswordVisible ? 'mdi-eye-off' : 'mdi-eye'"
                :type="confirmPasswordVisible ? 'text' : 'password'" density="compact"
                placeholder="Confirm your password" prepend-inner-icon="mdi-lock-outline" variant="outlined"
                v-model="confirmPassword" @click:append-inner="confirmPasswordVisible = !confirmPasswordVisible"
                :rules="confirmPasswordRules"></v-text-field>

            <v-card class="mb-12" color="surface-variant" variant="tonal">
                <v-card-text class="text-medium-emphasis text-caption">
                    Ensure that your password is strong and unique. If you need assistance, please refer to our help
                    section.
                </v-card-text>
            </v-card>

            <v-btn class="mb-8" color="blue" size="large" variant="tonal" block @click="register">
                Register
            </v-btn>

            <v-card-text class="text-center">
                <v-btn class="text-blue" @click="useRouter().push(Paths.login)">
                    Already have an account? <v-icon icon="mdi-chevron-right"></v-icon>
                </v-btn>
            </v-card-text>
        </v-form>
    </v-card>
</template>

<script setup lang="ts">
import type { VForm } from 'vuetify/components';
import { Paths } from '~/shared/paths';

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const passwordVisible = ref(false)
const confirmPasswordVisible = ref(false)
const emailRules = ref([
    (v: string) => !!v || 'Email is required',
    (v: string) => /.+@.+\..+/.test(v) || 'Email must be valid',
])
const passwordRules = ref([
    (v: string) => !!v || 'Password is required',
    (v: string) => v.length >= 6 || 'Password must be at least 6 characters',
])
const confirmPasswordRules = ref([
    (v: string) => !!v || 'Please confirm your password',
    (v: string) => v === password.value || 'Passwords must match',
])

export type UserRegisData = { email: string, password: string }
const emit = defineEmits<{ (e: "submit", data: UserRegisData): void }>()
const form = ref<VForm | null>(null);
const register = async () => {
    if (form.value == undefined) return;
    const { valid } = await form.value?.validate()
    if (valid) {
        emit('submit', { email: email.value, password: password.value });
    }
}
</script>
