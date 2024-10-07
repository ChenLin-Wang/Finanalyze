import Vapor
import Fluent

struct FileUploadC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let uploadRoute = routes.grouped("files")
        for t in [FileUpload.UploadType.avatar, FileUpload.UploadType.item] {
            let r = uploadRoute.grouped(.constant(t.rawValue))
            r.get(use: { try await getFileList(req: $0, type: t) })
            r.on(.POST, body: .collect(maxSize: "100mb"), use: { try await uploadFile(req: $0, type: t) })
        }
    }

    @Sendable func getFileList(req: Request, type: FileUpload.UploadType) async throws -> [FileUpload.DTO] {
        let user = try req.auth.require(User.self)
        let files = try await FileUpload.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$type == type.rawValue)
            .all()
        return try await files.dtos(req: req)
    }

    @Sendable func uploadFile(req: Request, type: FileUpload.UploadType) async throws -> FileUpload {
        let user = try req.auth.require(User.self)
        let pathComp = "uploads/" + type.rawValue + "/"
        let directory = DirectoryConfiguration.detect().workingDirectory + "Public/" + pathComp
        let file = try req.content.decode(FileUpload.NEW.self)
        let realName = RandomTimeBasedName() + "_" + file.name 
        let path = directory + realName
        let fileData = try FileUpload(userId: user.requireID(), path: "https://api.finanalyze.inspiral.site/" + pathComp + realName, type: type, data: file)
        try file.data.write(to: URL(fileURLWithPath: path))
        try await fileData.save(on: req.db)
        return fileData
    }
}