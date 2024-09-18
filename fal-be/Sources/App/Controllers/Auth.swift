import Vapor
import Fluent

struct AuthC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post(use: create)
    }

    @Sendable func create(req: Request) async throws -> User {
        print("hello")
        let userReq = try req.content.decode(User.REQ.self)
        print(userReq)
        let user = User(email: userReq.email, passwordHash: userReq.password)
        print(user)
        try await user.save(on: req.db)
        return user
    }
}