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
        let userDatas = try req.content.decode(User.NEW.self)
        let user = try User(data: userDatas)
        try await user.save(on: req.db)
        let infos = try UserInfo(userId: user.requireID())
        try await infos.save(on: req.db)
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