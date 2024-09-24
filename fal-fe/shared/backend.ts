const backend_defaults = {
    host: "localhost",
    port: 1511,
    head: "http://api.finanalyze.inspiral.site:1511",
    tokenKey: 'authToken',
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
    email: string
}

export type RegisPostRes = UserBasic

export type LoginPostRes = {
    token: string,
    user: UserBasic
}

export type InfoGetRes = {
    user: UserBasic
    username: string
    firstName?: string
    lastName?: string
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

export type ResError = {
    url: string,
    statusCode: number,
    statusMessage: string,
    message: string,
    description: string,
    data: {
        error: boolean,
        reason: string
    }
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