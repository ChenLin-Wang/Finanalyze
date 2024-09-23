/**
 * 格式化日期时间字符串
 *
 * @param value 待格式化的日期时间值，支持数字、字符串和 Date 类型，默认为当前时间戳
 * @param format 格式化字符串，默认为'YYYY-MM-DD HH:mm:ss'，支持格式化参数：YY：年，M：月，D：日，H：时，m：分钟，s：秒，SSS：毫秒
 * @returns 返回格式化后的日期时间字符串
 */
export function dateFormat(value: number | string | Date = Date.now(), format: string = 'YYYY-MM-DD HH:mm:ss'): string {
    try {
      let date: Date
      if (typeof value === 'number' || typeof value === 'string') {
        date = new Date(value)
        if (isNaN(date.getTime())) {
          throw new Error('Invalid date')
        }
      } else {
        date = value
      }
      const padZero = (value: number, len: number = 2): string => {
        // 左侧补零函数
        return String(value).padStart(len, '0')
      }
      const replacement = (match: string) => {
        switch (match) {
          case 'YYYY':
            return padZero(date.getFullYear())
          case 'YY':
            return padZero(date.getFullYear()).slice(2, 4)
          case 'MM':
            return padZero(date.getMonth() + 1)
          case 'M':
            return String(date.getMonth() + 1)
          case 'DD':
            return padZero(date.getDate())
          case 'D':
            return String(date.getDate())
          case 'HH':
            return padZero(date.getHours())
          case 'H':
            return String(date.getHours())
          case 'mm':
            return padZero(date.getMinutes())
          case 'm':
            return String(date.getMinutes())
          case 'ss':
            return padZero(date.getSeconds())
          case 's':
            return String(date.getSeconds())
          case 'SSS':
            return padZero(date.getMilliseconds(), 3)
          default:
            return match
        }
      }
      return format.replace(/YYYY|YY|MM|M|DD|D|HH|H|mm|m|ss|s|SSS/g, replacement)
    } catch (error) {
      throw new Error('Failed to format date')
    }
}
  

export function validateBirthDate(userDate: Date): string|true {
    const currentDate = new Date();
    // Check if userDate is a valid date and is not in the future
    if (userDate > currentDate) { return "Were you born in the future?" }
    // Perform additional validation if necessary, such as minimum age requirement
    const minAgeDate = new Date();
    minAgeDate.setFullYear(minAgeDate.getFullYear() - 80);
    if (userDate < minAgeDate) { return "Oh, you are too old." }
    return true;
}

export function DateToShortStr(date: Date): string {
    var d = date,
        month = '' + (d.getUTCMonth() + 1),
        day = '' + d.getUTCDate(),
        year = d.getUTCFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}