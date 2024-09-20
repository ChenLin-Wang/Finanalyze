const backend_defaults = {
    host: "localhost",
    port: 1511,
    head: "http://localhost:1511",
    tokenKey: 'authToken',
    api: {
        auth: {
            register: '/register',
            login: '/login'
        }
    }
}

export const be = backend_defaults

export type RegisPostRes = {
    email: string,
    username: string
}

export type LoginPostRes = {
    token: string
}

export const bearerFetch = async (url: string, options: any = {}) => {
    const config = useRuntimeConfig();
    options.headers = {
        ...options.headers,
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem(be.tokenKey) || ''}`,
    };
    return await $fetch(url, options);
}