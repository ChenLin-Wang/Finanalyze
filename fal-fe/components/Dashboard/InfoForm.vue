<script setup lang="ts">
import type { VForm } from 'vuetify/components';
import type { InfoGetRes, UserBasic } from '~/shared/backend';
import { deepCopy, deepEqual } from '~/shared/funcs';
import { digitLenValidate, emailValidate, numValidate, requireValidate, strLenValidate } from '~/shared/validations';

const emit = defineEmits(['update:infos', 'submit'])

enum Gender { male = "Male", female = "Female", none = "None" }

export type FormValue = {
    userId: string
    email: string
    username: string
    firstName: string
    lastName: string
    middleName?: string
    avatar?: string
    age?: number
    gender: string
    _bday?: string
    address?: string
    phoneNum?: string
    course?: string
    yearLvl?: string
    school?: string
}

const props = defineProps<{
    infos: FormValue
}>()

const form = ref<VForm | null>(null);
const values = ref<FormValue>(deepCopy(props.infos))

const submit = async () => {
    if (form.value == undefined) return;
    const { valid } = await form.value?.validate()
    if (valid) {
        var res = deepCopy(values.value)
        emit('submit', res);
    }
};

const titles = ["Account", "Basic Information", "Personal Information", "School Information"]

// [Label, Required?, Variable Name, Cols, Type, Validation]
const hintGroups = [
    [["Email", true, "email", "12", "string", true, [emailValidate("Email", false)]],],
    [["User Name", true, "username", "12", "string", false, [strLenValidate(2, "User Name", false)]],],

    [
        ["First Name", false, "firstName", "6", "string", false, [strLenValidate(2, "First Name", false)]],
        ["Last Name", false, "lastName", "6", "string", false, [strLenValidate(2, "Last Name", false)]],
    ],
    [["Middle Name", false, "middleName", "12", "string", false, []],],

    [["Gender", false, "gender", "12", "selector", false, [], [Gender.male, Gender.female, Gender.none]],],
    [["Age", false, "age", "12", "number", false, [numValidate(120, "Age", true), numValidate(0, "Age", false)]],],
    [["Birthday", false, "_bday", "12", "date", false, [], "bdayDate", [-3784320000, 0]],],
    [["Phone Number", false, "phoneNum", "12", "string", false, [digitLenValidate(7, "Phone Number", false, true), digitLenValidate(15, "Phone Number", true, true)]],],
    [["Address", false, "address", "12", "string", false, []],],

    [["School", false, "school", "12", "string", false, []],],
    [
        ["Course", false, "course", "8", "string", false, []],
        ["Year Level", false, "yearLvl", "4", "selector", false, [], ["None", "1st", "2nd", "3rd", "4th", "Higher"]],
    ],
]

</script>

<template>
    <v-container fluid>
        <v-form @submit.prevent="submit" ref="form">
            <div class="my-0" v-for="(indexes, j) in [[0, 2], [2, 4], [4, 9], [9, 11]]" :key="j">
                <h4 class="py-0 mt-0 mb-2">{{
                    titles[j] }}</h4>
                <v-row class="my-0 mx-1" v-for="(hints, i) in hintGroups.slice(indexes[0], indexes[1])" :key="i">
                    <v-col class="my-0 pt-0 pa-0" v-for="(hint, index) in hints" :key="index" :cols="<string>hint[3]">
                        <v-select v-if="<string>hint[4] === 'selector'"
                            :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model="<any>values[<keyof FormValue>hint[2]]" :items="hint[7] as Array<string>" 
                            :type="typeof values[<keyof FormValue>hint[2]]" :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])">
                        </v-select>
                        <DateField v-else-if="<string>hint[4] === 'date'"
                            :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model:dateStr="<string>values[<keyof FormValue>hint[2]]"
                            v-model:date="<Date>values[<keyof FormValue>hint[7]]" :disabled="<boolean>hint[5]"
                            :min="new Date(Date.parse(new Date().toString()) + (<number[]>hint[8])[0] * 1000)"
                            :max="new Date(Date.parse(new Date().toString()) + (<number[]>hint[8])[1] * 1000)"
                            variant="filled" :rules=" /* @ts-ignore */hint[6]">
                        </DateField>
                        <v-text-field v-else-if="<string>hint[4] === 'string'" :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model="values[<keyof FormValue>hint[2]]" type="string" :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])">
                        </v-text-field>
                        <v-text-field v-else-if="<string>hint[4] === 'number'" :label="<string>hint[0] + (hint[1] ? ' *' : '')"
                            v-model.number="values[<keyof FormValue>hint[2]]" type="number" :disabled="<boolean>hint[5]"
                            :rules="(hint[1] ? [requireValidate('string', <string>hint[0])] : []).concat(<Array<(v: any) => string | true>>hint[6])">
                        </v-text-field>
                    </v-col>
                </v-row>
            </div>
            <v-row class="mt-5 mx-1">
                <v-btn class="text-none" :disabled="deepEqual(values, infos)" color="white" width="100%"
                    @click="submit">Submit</v-btn>
            </v-row>
        </v-form>
    </v-container>
</template>
