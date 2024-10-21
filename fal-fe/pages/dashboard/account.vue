<script setup lang="ts">
import type { FormValue } from '~/components/Dashboard/InfoForm.vue';
import type { AlertDatas, LoadingStatus } from '~/layouts/default.vue';
import { be, BearerFetch, type FileUploadRes, type InfoGetRes, type ResError } from '~/shared/backend';
import { DateToShortStr } from '~/shared/dateFunctions';
import { deepCopy } from '~/shared/funcs';
import { globalKeys } from '~/shared/paths';

const infos = ref(inject(globalKeys.userInfosKey) as InfoGetRes)
const alertDatas = ref(inject(globalKeys.dashboardAlertKey) as AlertDatas)
const contentLoading = ref(inject(globalKeys.dashboardLoadingKey) as LoadingStatus)
const barTitle = ref(inject(globalKeys.dashboardBarTitle) as string)

const imgLoading = ref(false)

const photoPath = ref<string | null>(null)

barTitle.value = "Account Information"

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
    contentLoading.value.content = true
    var vals = deepCopy(value)
    if (vals._bday) vals._bday = DateToShortStr(new Date(vals._bday))
    if (photoPath.value) vals.avatar = photoPath.value
    if (typeof vals.age === "string") vals.age = undefined
    try {
        const submitRes: InfoGetRes = await BearerFetch(be.head + be.api.userspace.info, {
            method: 'POST',
            body: vals
        }) as InfoGetRes
        infos.value = submitRes
        alertDatas.value = {
            info: "You informations is updated.",
            type: "success",
            title: "Update successfully!",
            show: true
        }
    } catch (error) {
        errHandle(error as ResError)
    } finally {
        contentLoading.value.content = false
    }
}

const getImage = async (img: File) => {
    imgLoading.value = true
    try {
        const formData = new FormData();
        formData.append('data', img)
        formData.append('name', img.name)
        formData.append('detect', 'false')
        const res = await BearerFetch(be.head + be.api.userspace.files + "/avatar", {
            "Content-Type": "multipart/form-data",
            method: "POST",
            body: formData
        }) as FileUploadRes
        photoPath.value = res.path
    } catch (err) {
        errHandle(err as ResError)
    } finally {
        imgLoading.value = false
    }
}

const cancelAvatar = () => {
    photoPath.value = null
}

const errHandle = (error: ResError) => {
    alertDatas.value = {
        info: error as ResError,
        type: "error",
        title: "Update Failed!",
        show: true
    }
}

</script>

<template>
    <h4 class="py-0 ma-4 mb-3">Avatar</h4>
    <DashboardPhoto @useImage="getImage" :rounded="true" @clear="cancelAvatar"/>
    <DashboardInfoForm class="pt-0 mt-0" v-if="!imgLoading" @submit="submit" :infos="toFormValue(infos)" :always-enable-submit="photoPath !== null"/>
    <v-skeleton-loader v-else color="white" :elevation="0" class="ma-0 border pa-0 fill-width fill-height" type="card, table"/>
</template>