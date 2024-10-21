<script setup lang="ts">
import type { VNodeRef } from 'vue';
import { useDisplay } from 'vuetify';

const file = ref<File | null>(null)
const imageUrl = ref<string | null>(null)
const popover = ref(false)
const videoStream = ref<MediaStream | null>(null)
const video = ref<VNodeRef | null>(null)

const props = withDefaults(defineProps<{
    rounded?: boolean
}>(), {
    rounded: true
})

const emit = defineEmits<{
    (e: "useImage", imageUrl: File): void,
    (e: "clear"): void
}>()

const onFileChange = (files: File | File[]) => {
    if (files instanceof File) imageUrl.value = URL.createObjectURL(files)
    else if (Array.isArray(files) && files.length > 0) {
        imageUrl.value = URL.createObjectURL(files[0]);
    }
}

const openCamera = async () => {
    try {
        videoStream.value = await navigator.mediaDevices.getUserMedia({ video: true })
        video.value.srcObject = videoStream.value
    } catch (error) {
        console.error('Error accessing camera:', error)
    }
};

const capturePhoto = () => {
    closePopover();
    const canvas = document.createElement('canvas');
    canvas.width = video.value.videoWidth;
    canvas.height = video.value.videoHeight;
    const context = canvas.getContext('2d');
    if (context) {
        context.drawImage(video.value, 0, 0, canvas.width, canvas.height);
        const dataURL = canvas.toDataURL('image/png');
        file.value = dataURLtoFile(dataURL, 'photo.png');
        imageUrl.value = URL.createObjectURL(file.value);
    }
};

const dataURLtoFile = (dataURL: string, filename: string): File => {
    const arr = dataURL.split(',');
    const mime = arr[0].match(/:(.*?);/)?.[1] || '';
    const bstr = atob(arr[1]);
    let n = bstr.length;
    const u8arr = new Uint8Array(n);
    while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, { type: mime });
};

const openPopover = () => { 
    popover.value = true
    openCamera()
}

const closePopover = () => {
    popover.value = false
    if (videoStream.value) { videoStream.value.getTracks().forEach((track) => track.stop()) }
}

const cancelImg = () => {
    file.value = null
    imageUrl.value = null
    closePopover()
    emit("clear")
}

onUnmounted(() => { closePopover() })

const isSmallScreen = () => {
    if (process.server) return false
    return useDisplay().width.value < 550
}

</script>

<template>
    <v-container class="py-0 pb-3" fluid>
        <v-row no-gutters align="center" justify="center">
            <v-col class="pa-2" :cols="isSmallScreen() ? '12' : '8'">
                <v-file-input
                    v-model="file" 
                    label="Upload an Image" 
                    accept="image/*" 
                    prepend-icon=""
                    prepend-inner-icon="mdi-camera"
                    :variant="rounded ? 'solo' : 'underlined'"
                    :rounded="rounded"
                    chips
                    hide-details
                    @update:model-value="onFileChange" />
            </v-col>
            <v-col class="text-center pa-0 ma-0" cols="1">
                <p>Or</p>
            </v-col>
            <v-col class="pa-2" :cols="isSmallScreen() ? '' : '3'">
                <v-btn :rounded="rounded" @click="openPopover" style="width: 100%; height: 56px; overflow: hidden">Take Picture</v-btn>
            </v-col>
            <v-col class="pa-2" v-if="imageUrl" cols="12" align="center" justify="center">
                <v-card class="pa-3" style="position: relative; border-radius: 20px;" elevation="4">
                    <v-btn icon="mdi-close-circle-outline" @click="cancelImg" variant="text" style="
                        position: absolute;
                        right: 0px;
                        top: 0px;
                        z-index: 10;
                    "/>
                    <v-img :src="imageUrl" max-height="300" />
                </v-card>
            </v-col>
            <v-col class="pa-2" v-if="imageUrl" cols="12">
                <!-- @vue-ignore -->
                <v-btn rounded @click="emit('useImage', file)" style="width:100%">Use Image</v-btn>
            </v-col>
            <v-dialog
                v-model="popover"
                fullscreen
                hide-overlay
                @after-leave="closePopover"
                transition="dialog-bottom-transition">
                <v-card class="fill-height fill-width d-flex flex-column">
                    <video class="flex-grow-1 py-auto" ref="video" autoplay playsinline style="max-height: calc(100% - 50px);" />
                    <v-spacer/>
                    <v-card-actions class="flex-shrink-0">
                        <v-btn @click="capturePhoto">Capture Photo</v-btn>
                        <v-btn @click="closePopover">Close</v-btn>
                    </v-card-actions>
                </v-card>
            </v-dialog>
        </v-row>
    </v-container>
</template>