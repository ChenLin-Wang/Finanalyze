import Vapor
import Fluent

struct AuthC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)
        let basicProtected = routes.grouped(User.authenticator())
        basicProtected.post("login", use: login)
    }

    @Sendable func create(req: Request) async throws -> User {
        try User.DTO.validate(content: req)
        let userReq = try req.content.decode(User.REQ.self)
        let user = try User(email: userReq.email, passwordHash: Bcrypt.hash(userReq.password))
        try await user.save(on: req.db)
        return user
    }

    @Sendable func login(req: Request) async throws -> Token {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await Token.query(on: req.db).filter(\.$user.$id == user.requireID()).delete()
        try await token.save(on: req.db)
        return token
    }
}