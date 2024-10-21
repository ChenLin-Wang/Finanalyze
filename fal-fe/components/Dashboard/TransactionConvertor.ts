import type { FileUploadRes, TransactionRes } from "~/shared/backend"

export type TransactionValue = {
    id: string
    itemName: string
    itemAmount: number
    pricePerUnit: number
    location: string
    brand?: string
    category: string
    __transactionDate: string
    imgPath?: FileUploadRes
    user?: {
        email: string,
        username: string,
        avatar: string
    }
}

export function toFormValue(value: TransactionRes): TransactionValue {
    return {
        id: value.id,
        itemName: value.itemName,
        itemAmount: +value.itemAmount,
        pricePerUnit: +value.pricePerUnit,
        location: value.location,
        brand: value.brand,
        category: value.category,
        __transactionDate: value.transactionDate.split('T')[0],
        imgPath: value.imgPath
    }
}

export function toFormRes(value: TransactionValue): TransactionRes {
    return {
        id: value.id,
        itemName: value.itemName,
        itemAmount: +value.itemAmount,
        pricePerUnit: +value.pricePerUnit,
        location: value.location,
        brand: value.brand,
        category: value.category,
        transactionDate: value.__transactionDate,
        imgPath: value.imgPath
    }
}