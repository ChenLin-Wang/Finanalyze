import Vapor
import Fluent
import SQLKit

final class FileUpload: DModel, @unchecked Sendable {
    static let schema = TableNames.fileUploads
    static let nullID: IDValue = .init(uuidString: "00000000-0000-0000-0000-000000000000")!
    enum UploadType: String, Codable {
        case avatar = "avatar", item = "item"
    }
    
    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("name", .string, [.required], false),
        ("path", .string, [.required], false),
        ("type", .string, [.required], false),
        ("created_at", .string, [.required], false),
    ]

    @ID(key: .id)                                       var id: UUID?
    @Parent(key: T[1].0)                                var user: User
    @Field(key: T[2].0)                                 var name: String
    @Field(key: T[3].0)                                 var path: String
    @Field(key: T[4].0)                                 var type: String
    @Timestamp(key: T[5].0, on: .create, 
    format: .iso8601(withMilliseconds: true))           var createdAt: Date? 
                                                        var detect: [DTO.Detect]

    typealias REQ = User.REQ

    struct NEW: Content, Sendable {
        var name: String
        var data: Data
        var detect: Bool
    }

    struct DTO: Content, Sendable { 
        var id: FileUpload.IDValue
        var name: String
        var path: String
        var type: UploadType
        var createdAt: Date
        var detect: [Detect]
        struct Detect: Content, Sendable {
            var description: String
            var score: Float
            var confidence: Float
        }
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard 
            let createDate = self.createdAt,
            let type = UploadType(rawValue: self.type)
        else { throw Abort(.badRequest, reason: "Wrong createAt value") }
        return try DTO(id: self.requireID() ,name: self.name, path: self.path, type: type, createdAt: createDate, detect: self.detect)
    }

    init() { self.detect = []}

    convenience init(userId: User.IDValue, path: String, type: UploadType, detect: [DTO.Detect] = [], data: NEW) throws {
        self.init(userId: userId, name: data.name, path: path, type: type, detect: detect)
    }

    init(
        id: IDValue? = nil,
        userId: User.IDValue,
        name: String,
        path: String,
        type: UploadType,
        detect: [DTO.Detect] = [],
        createdAt: Date? = nil
    ) {
        self.detect = detect
        self.id = id
        self.$user.id = userId
        self.name = name
        self.path = path
        self.type = type.rawValue
        self.createdAt = createdAt
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = FileUpload }
}

extension FileUpload.MIG {
    func migrationFinished(on database: Database) {
        let _ = FileUpload(id: FileUpload.nullID, userId: User.nullID, name: "-", path: "-", type: .item).save(on: database)
    }
}