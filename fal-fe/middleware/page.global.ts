export default defineNuxtRouteMiddleware((to, from) => {
    // console.log(from.fullPath)
    if (to.fullPath === '/dashboard') {
        const session = useCookie('session')
        if (!session.value) return to.fullPath == from.fullPath ? navigateTo('/') : from.fullPath
    }
})