<script setup lang="ts">
import type { FormValue } from '~/components/Dashboard/InfoForm.vue';
import { be, BearerFetch, type InfoGetRes } from '~/shared/backend';
import { DateToShortStr } from '~/shared/dateFunctions';
import { deepCopy } from '~/shared/funcs';
import { globalKeys } from '~/shared/paths';

const infos = ref(inject(globalKeys.userInfosKey) as InfoGetRes)

function toFormValue(info: InfoGetRes): FormValue {
    return {
        userId: info.user.id,
        email: info.user.email,
        username: info.username,
        firstName: info.firstName,
        lastName: info.lastName,
        middleName: info.middleName,
        avatar: info.avatar,
        age: info.age === undefined ? undefined : +(info.age),
        gender: info.gender,
        _bday: info.birthday ? info.birthday.split('T')[0] : undefined,
        address: info.address,
        phoneNum: info.phoneNum,
        course: info.course,
        yearLvl: info.yearLvl,
        school: info.school
    };
}

const submit = async (value: FormValue) => {
    var vals = deepCopy(value)
    if (vals._bday) { vals._bday = DateToShortStr(new Date(vals._bday)) }
    if (typeof vals.age === "string") vals.age = undefined
    try {
        const submitRes: InfoGetRes = await BearerFetch(be.head + be.api.dashboard.info, {
            method: 'POST',
            body: vals
        }) as InfoGetRes
        infos.value = submitRes
    } catch (error) {

    } finally {

    }
}

</script>

<template>
    <v-container fluid>
        <DashboardInfoForm @submit="submit" :infos="toFormValue(infos)"></DashboardInfoForm>
    </v-container>
</template>