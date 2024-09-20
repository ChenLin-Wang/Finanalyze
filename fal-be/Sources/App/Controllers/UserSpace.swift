import Vapor
import Fluent

struct UserSpace: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("me", use: me)
    }
    
    @Sendable func me(req: Request) async throws -> User {
        try req.auth.require(User.self)
    }
}