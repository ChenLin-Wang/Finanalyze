import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthC())
    let protected = app.grouped(Token.authenticator())
    let userSpace = protected.grouped("userspace")
    try userSpace.register(collection: UserInfoC())
    try userSpace.register(collection: TransactionC())
    try userSpace.register(collection: FileUploadC())
    try userSpace.register(collection: AiChatC())
    try userSpace.register(collection: OverviewC())
}
