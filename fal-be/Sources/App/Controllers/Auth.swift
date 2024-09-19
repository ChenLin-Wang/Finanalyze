import Vapor
import Fluent

struct AuthC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: create)
        let protected = routes.grouped(User.authenticator())
        protected.post("login") { req -> User in
            try req.auth.require(User.self)
        }
    }

    @Sendable func create(req: Request) async throws -> User {
        try User.DTO.validate(content: req)
        let userReq = try req.content.decode(User.REQ.self)
        let user = try User(email: userReq.email, passwordHash: Bcrypt.hash(userReq.password))
        try await user.save(on: req.db)
        return user
    }

    // @Sendable func authenticate(req: Request) async throws -> Session {
        


    //     return Session()
    // }
}