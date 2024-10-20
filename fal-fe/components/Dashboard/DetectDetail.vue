<script setup lang="ts">
import type { VForm } from 'vuetify/components';
import { CategoryIcons } from '~/shared/parameters';
import { numValidate } from '~/shared/validations';

const form = ref<VForm | null>(null)

export type Detail = {
    totalPrice: number,
    amount: number,
    category: keyof typeof CategoryIcons,
    brand?: string
}

const detail = ref({
    totalPrice: 1,
    amount: 1,
    category: "Food"
} as Detail)

const emit = defineEmits<{
    (e: "detailApplied", detail: Detail): void
}>()

const detailApplied = async () => {
    if (form.value == undefined) return;
    console.log(detail.value)
    const { valid } = await form.value?.validate()
    if (valid) emit("detailApplied", detail.value)
}

</script>

<template>
    <v-container class="py-0 pb-3" fluid>
        <v-card style="border-radius: 20px;" elevation="4">
            <v-card-title>Add details</v-card-title>
            <v-card-subtitle>No need other informations any more</v-card-subtitle>
            <v-form @detailApplied.prevent="detailApplied" ref="form">
                <v-row no-gutters class="mt-3">
                    <v-col class="px-3" cols="6">
                        <v-text-field 
                            rounded 
                            v-model.number="detail.totalPrice"
                            variant="solo" 
                            label="Total Price *" 
                            type="number"
                            :rules="[numValidate(0, 'Total Price', false, false)]"
                        />
                    </v-col>
                    <v-col class="px-3" cols="6">
                        <v-text-field
                            rounded 
                            v-model.number="detail.amount"
                            variant="solo" 
                            label="Amounts *" 
                            type="number"
                            :rules="[numValidate(1, 'Total Price', false, false)]"
                        />
                    </v-col>
                    <v-col class="px-3" cols="6">
                        <v-text-field
                            rounded
                            v-model="detail.brand"
                            variant="solo"
                            label="Brand"
                        />
                    </v-col>
                    <v-col class="px-3" cols="6">
                        <v-select
                            rounded
                            v-model="detail.category"
                            :items="Object.keys(CategoryIcons).sort()"
                            variant="solo"
                            label="Brand"
                        />
                    </v-col>
                </v-row>
            </v-form>
            <v-card-actions>
                <v-btn @click="detailApplied">Done</v-btn>
            </v-card-actions>
        </v-card>
    </v-container>
</template>