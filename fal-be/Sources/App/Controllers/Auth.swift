import Vapor
import Fluent

struct AuthC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post(use: create)
    }

    @Sendable func create(req: Request) async throws -> User {
        let userReq = try req.content.decode(User.REQ.self)
        let user = User(email: userReq.email, passwordHash: userReq.password)
        try await user.save(on: req.db)
        return user
    }

    // @Sendable func find(req: Request) async throws -> [User] {
        
    // }
}