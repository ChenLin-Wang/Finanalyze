import Vapor
import Fluent

struct UserSpace: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userRoute = routes.grouped("user")
        let infoRoute = userRoute.grouped("info")
        infoRoute.get(use: getInfos)
        infoRoute.post(use: updateInfos)
    }
    
    @Sendable func getInfos(req: Request) async throws -> UserInfo {
        try req.auth.require(User.self)
        let reqData = try req.content.decode(UserInfo.REQ.self)
        guard let infos = try await UserInfo.query(on: req.db).filter(\.$user.$id == reqData.userId).first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        return infos
    }

    @Sendable func updateInfos(req: Request) async throws -> UserInfo {
        try req.auth.require(User.self)
        let createDatas = try req.content.decode(UserInfo.NEW.self)
        let infos = try UserInfo(data: createDatas)
        try await infos.save(on: req.db)
        return infos
    }
}