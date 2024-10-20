const backend_defaults = {
    host: "localhost",
    port: 1511,
    head: "https://api.finanalyze.inspiral.site",
    tokenKey: 'authToken',
    api: {
        auth: {
            register: '/register',
            login: '/login'
        },
        userspace: {
            info: '/userspace/info',
            transactions: {
                normal: '/userspace/transactions',
                all: '/userspace/transactions/all'
            },
            files: '/userspace/files',
            ai: {
                chats_get: '/userspace/ai',
                chat: '/userspace/ai/chat'
            },
            overview: {
                summary: "/userspace/overview/summary",
                timeline: "/userspace/overview/timeline",
                category: "/userspace/overview/category",
                item: "/userspace/overview/item"
            },
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
    avatar: string
    age?: number
    gender: string
    birthday?: string
    address?: string
    phoneNum?: string
    course?: string
    yearLvl?: string
    school?: string
}

export type TransactionRes = {
    id: string
    itemName: string
    itemAmount: number
    pricePerUnit: number
    location: string
    brand?: string
    category: string
    transactionDate: string
    imgPath?: FileUploadRes
}

export type AiAnsRes = {
    id: string
    title: string
    contents: { role: string, content: string }[]
    createdAt: string
    updatedAt: string
}

export type SummaryRes = {
    totalCost: number
    totalCount: number
    currentMonthCost: number
    currentMonthCount: number
    lastMonthCost: number
    lastMonthCount: number
}

export type AllTransRes = {
    user: { email: string, username: string, avatar: string },
    transaction: TransactionRes
}

export type TimelineRes = {
    date: string
    costWeight: number
    countWeight: number
}

export type CategoryRes = {
    name: string
    costWeight: number
    countWeight: number
}

export type Detect = {
    description: string
    score: number
    confidence: number
}

export type FileUploadRes = {
    id: string
    name: string
    path: string
    type: string
    createdAt: string
    detect: Detect[]
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
    options.headers = {
        ...options.headers,
        Authorization: `Bearer ${localStorage.getItem(be.tokenKey) || ''}`,
    };
    return await $fetch(url, options);
}