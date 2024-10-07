import Vapor

func RandomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func RandomTimeBasedName() -> String {
    let timestamp = Int(Date().timeIntervalSince1970 * 1000)
    let randomValue = UUID().uuidString.prefix(8)
    return "\(timestamp)_\(randomValue)"
}