import { Paths } from "./paths";

export function delay(ms: number) {
    return new Promise( resolve => setTimeout(resolve, ms) );
}

export function deepEqual(obj1: any, obj2: any): boolean {
    if (obj1 === obj2) return true
    if (typeof obj1 !== 'object' || typeof obj2 !== 'object' || obj1 === null || obj2 === null) return false;
    const keys1 = Object.keys(obj1);
    const keys2 = Object.keys(obj2);
    if (keys1.length !== keys2.length) return false;
    for (const key of keys1)
        if (!keys2.includes(key) || !deepEqual(obj1[key], obj2[key])) return false;
    return true;
}

export function deepCopy<T>(obj: T): T {
    if (obj === null || typeof obj !== "object") return obj;
    if (Array.isArray(obj)) return obj.map(item => deepCopy(item)) as unknown as T;
    const result: any = {};
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            result[key] = deepCopy((obj as any)[key]);
        }
    }
    return result;
}

export function localClear() {
    localStorage.clear()
    useRouter().push(Paths.home)
}