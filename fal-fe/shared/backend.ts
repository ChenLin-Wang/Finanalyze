const backend_defaults = {
    host: "localhost",
    port: 1511,
    head: "http://localhost:1511",
    tokenKey: 'authToken',
    userIdKey: 'userId',
    api: {
        auth: {
            register: '/register',
            login: '/login'
        },
        dashboard: {
            info: '/user/info'
        }
    }
}

export const be = backend_defaults

export type UserBasic = {
    id: string,
    email: string,
    username: string
}

export type RegisPostRes = UserBasic

export type LoginPostRes = {
    token: string,
    user: UserBasic
}

export type InfoGetRes = {
    user: UserBasic,
    firstName: string
    lastName: string
    middleName?: string
    avatar?: string
    age?: number
    gender: string
    birthday?: string
    address?: string
    phoneNum?: string
    course?: string
    yearLvl?: string
    school?: string

}

export const BearerFetch = async (url: string, options: any = {}) => {
    const config = useRuntimeConfig();
    options.headers = {
        ...options.headers,
        "Content-Type": "application/json",
        Authorization: `Bearer ${localStorage.getItem(be.tokenKey) || ''}`,
    };
    return $fetch(url, options);
}