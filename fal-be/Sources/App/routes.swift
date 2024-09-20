import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthC())
    let protected = app.grouped(Token.authenticator())
    try protected.register(collection: UserSpace())
}
