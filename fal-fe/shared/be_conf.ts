export const be_paras = {
    host: "localhost",
    port: 1511,
    head: "http://localhost:1511"
}

export const be_api = {
    auth: {
        register: '/auth'
    }
}

export type AuthPostRes = {
    email: string,
    username: string,
    id: string
}