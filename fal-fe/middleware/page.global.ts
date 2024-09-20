import { be } from "~/shared/backend"
import { Paths } from "~/shared/paths"

export default defineNuxtRouteMiddleware((to, from) => {
    const token = localStorage.getItem(be.tokenKey)
    if (to.fullPath === Paths.dashboard && !token) return to.fullPath == from.fullPath ? navigateTo(Paths.home) : from.fullPath
    if ((to.fullPath === Paths.login || to.fullPath === Paths.register || to.fullPath === Paths.home) && token) return navigateTo(Paths.dashboard)
})