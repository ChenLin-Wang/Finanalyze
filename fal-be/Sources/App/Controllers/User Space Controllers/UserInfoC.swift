import Vapor
import Fluent

struct UserInfoC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let infoRoute = routes.grouped("info")
        infoRoute.get(use: getInfos)
        infoRoute.post(use: updateInfos)
    }
    
    @Sendable func getInfos(req: Request) async throws -> UserInfo {
        let user = try req.auth.require(User.self)
        guard let infos = try await UserInfo.query(on: req.db).filter(\.$user.$id == user.requireID()).first()  else {
            throw Abort(.notFound, reason: "User not found")
        }
        return infos
    }

    @Sendable func updateInfos(req: Request) async throws -> UserInfo {
        try req.auth.require(User.self)
        let createDatas = try req.content.decode(UserInfo.NEW.self)
        let infos: UserInfo = try UserInfo(data: createDatas)
        try await UserInfo.query(on: req.db)
            .set([
                UserInfo.T[2].0: .bind(infos.username),
                UserInfo.T[3].0: .bind(infos.firstName),
                UserInfo.T[4].0: .bind(infos.middleName),
                UserInfo.T[5].0: .bind(infos.lastName),
                UserInfo.T[6].0: .bind(infos.avatar),
                UserInfo.T[7].0: .bind(infos.age),
                UserInfo.T[8].0: .bind(infos.gender),
                UserInfo.T[9].0: .bind(infos.birthday),
                UserInfo.T[10].0: .bind(infos.address),
                UserInfo.T[11].0: .bind(infos.phoneNum),
                UserInfo.T[12].0: .bind(infos.course),
                UserInfo.T[13].0: .bind(infos.yearLvl),
                UserInfo.T[14].0: .bind(infos.school),
            ])
            .filter(\.$user.$id == infos.$user.id).update()
        return infos
    }

}