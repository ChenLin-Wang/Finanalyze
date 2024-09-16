<template>
    <div>
        <v-card class="mx-auto pa-12 pb-8" elevation="8" max-width="448" rounded="lg">
            <div class="text-subtitle-1 text-medium-emphasis">Create an Account</div>

            <v-text-field 
                density="compact" 
                placeholder="Email address" 
                prepend-inner-icon="mdi-email-outline"
                variant="outlined"
                v-model="email"
                :rules="[emailRules]"
            ></v-text-field>

            <div class="text-subtitle-1 text-medium-emphasis d-flex align-center justify-space-between">
                Password
            </div>

            <v-text-field 
                :append-inner-icon="passwordVisible ? 'mdi-eye-off' : 'mdi-eye'" 
                :type="passwordVisible ? 'text' : 'password'"
                density="compact" 
                placeholder="Enter your password" 
                prepend-inner-icon="mdi-lock-outline"
                variant="outlined" 
                v-model="password"
                @click:append-inner="passwordVisible = !passwordVisible"
                :rules="[passwordRules]"
            ></v-text-field>

            <v-text-field 
                :append-inner-icon="confirmPasswordVisible ? 'mdi-eye-off' : 'mdi-eye'" 
                :type="confirmPasswordVisible ? 'text' : 'password'"
                density="compact" 
                placeholder="Confirm your password" 
                prepend-inner-icon="mdi-lock-outline"
                variant="outlined"
                v-model="confirmPassword"
                @click:append-inner="confirmPasswordVisible = !confirmPasswordVisible"
                :rules="[confirmPasswordRules]"
            ></v-text-field>

            <v-card class="mb-12" color="surface-variant" variant="tonal">
                <v-card-text class="text-medium-emphasis text-caption">
                    Ensure that your password is strong and unique. If you need assistance, please refer to our help section.
                </v-card-text>
            </v-card>

            <v-btn 
                class="mb-8" 
                color="blue" 
                size="large" 
                variant="tonal" 
                block
                @click="register"
            >
                Register
            </v-btn>

            <v-card-text class="text-center">
                <a class="text-blue text-decoration-none" href="#" rel="noopener noreferrer" target="_blank">
                    Already have an account? <v-icon icon="mdi-chevron-right"></v-icon>
                </a>
            </v-card-text>
        </v-card>
    </div>
</template>

<script>
export default {
    data: () => ({
        email: '',
        password: '',
        confirmPassword: '',
        passwordVisible: false,
        confirmPasswordVisible: false,
        emailRules: [
            v => !!v || 'Email is required',
            v => /.+@.+\..+/.test(v) || 'Email must be valid',
        ],
        passwordRules: [
            v => !!v || 'Password is required',
            v => v.length >= 6 || 'Password must be at least 6 characters',
        ],
        confirmPasswordRules: [
            v => !!v || 'Please confirm your password',
            v => v === this.password || 'Passwords must match',
        ],
    }),
    methods: {
        register() {
            // Handle registration logic here
            if (this.$refs.form.validate()) {
                // Submit registration form
            }
        }
    }
}
</script>
