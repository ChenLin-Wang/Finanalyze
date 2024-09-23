import Vapor

func ShortDateFormatter() -> DateFormatter {
    let df = DateFormatter()
    df.timeZone = TimeZone(secondsFromGMT: 0)
    df.dateFormat = "yyyy-MM-dd"
    return df
}