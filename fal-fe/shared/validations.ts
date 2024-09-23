export const requireValidate = (t: string, label: string) => {
    if (t === "string") { return (v: string) => !!v || `${label} is required` }
    else { return (v: any) => true }
}

export const strLenValidate = (len: number, label: string, less: boolean = true) => {
    return (v: string) => (less ? v?.length <= len : v?.length >= len) || `${label} needs to be ${less ? 'short than' : 'at least'} ${len} characters.`
}

export const numValidate = (boundary: number, label: string, less: boolean = true, allowEmpty: boolean = false) => {
    return (v?: number) => {
        let val = v
        if (typeof val === "string") val = undefined
        return val === undefined ? (allowEmpty ? true : `${label} must not be empty.`) :
        (less ? val > boundary : val < boundary) ? `${label} needs to be ${less ? 'smaller than' : 'larger than'} ${boundary}.` : true
    }
}

export const digitLenValidate = (digitLen: number, label: string, less: boolean = false, allowEmpty: boolean = false) => {
    return (v: string) => {
        if (allowEmpty && (!v || v === "")) return true
        if (!/^\d+$/.test(v)) return `${label} can only contain digits.`
        const digitCount = v.length;
        if (less) return digitCount < digitLen || `${label} needs to be less than ${digitLen} digits.`;
        else return digitCount >= digitLen || `${label} needs to be at least ${digitLen} digits.`;
    };
};

export const emailValidate = (label: string = "Email", allowEmpty: boolean = false) => {
    return (v: string) => (!v && allowEmpty) ? true : (/.+@.+\..+/.test(v) || `${label} must be valid`)
}