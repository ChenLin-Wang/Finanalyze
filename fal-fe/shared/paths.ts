export const Paths = {
    home: "/",
    login: "/login",
    register: "/register",
    dashboard: "/dashboard"
}

export const globalKeys = {
    userInfosKey: "user-infos-key",
    dashboardAlertKey: "dashboard-alert-key",
    dashboardLoadingKey: "dashboard-loading-key",
    userIdKey: "user-id-key",
}

export const getUserSpaceItem = (name: string): {title: string, link: string, icon: string} => userSpaceItems[userSpaceItems.findIndex( a => a.title === name )]

export const userSpaceItems = [
    {
        title: "Overview",
        link: "/dashboard",
        icon: "mdi-sprout-outline"
    }, {
        title: "Account",
        link: "/dashboard/account",
        icon: "mdi-account-circle-outline"
    }, {
        title: "Transactions",
        link: "/dashboard/transactions",
        icon: "mdi-shopping-outline"
    }, {
        title: "AI Analytic",
        link: "/dashboard/ai_analytic",
        icon: "mdi-google-analytics"
    }, {
        title: "Find",
        link: "/dashboard/find",
        icon: "mdi-tag-search-outline"
    }, {
        title: "Share",
        link: "/dashboard/share",
        icon: "mdi-share-all-outline"
    }, {
        title: "Settings",
        link: "/dashboard/settings",
        icon: "mdi-cog"
    }
]