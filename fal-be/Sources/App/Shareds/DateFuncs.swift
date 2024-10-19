import Vapor

func ShortDateFormatter() -> DateFormatter {
    let df = DateFormatter()
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "yyyy-MM-dd"
    return df
}

extension Date {
    func nextMonthStart(length: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.month = (components.month ?? 0) + length
        components.day = 1
        return calendar.date(from: components)!
    }

    func nextYearStart(length: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: self)
        components.year = (components.year ?? 0) + length
        components.month = 1
        components.day = 1
        return calendar.date(from: components)!
    }

    func nextDayStart(length: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = (components.day ?? 0) + length
        return calendar.date(from: components)!
    }

    func previousMonthStart(length: Int) -> Date {
        guard length > 0 else { return self }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.month = (components.month ?? 0) - length - (components.day != 1 ? 1 : 0)
        components.day = 1
        return calendar.date(from: components)!
    }
}