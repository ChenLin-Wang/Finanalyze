<template>
    <h1 class="bar-title" @click="useRouter().push(Paths.home)">Finanalyze</h1>
</template>

<script setup>
import { Paths } from '~/shared/paths';
</script>

<style lang="css" scoped>
.bar-title {
    font-family: var(--Protest-Guerrilla);
    font-size: 30px;
    font-weight: 400;
    cursor: pointer; /* 改变鼠标指针 */
    transition: color 0.3s; /* 添加过渡效果 */
}

</style>