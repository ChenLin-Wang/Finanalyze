import Vapor
import Fluent
import SQLKit

final class FileUpload: DModel, @unchecked Sendable {
    static let schema = TableNames.fileUploads
    
    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("name", .string, [.required], false),
        ("path", .string, [.required], false),
        ("created_at", .string, [.required], false),
    ]

    @ID(key: .id)                                       var id: UUID?
    @Parent(key: T[1].0)                                var user: User
    @Field(key: T[2].0)                                 var name: String
    @Field(key: T[3].0)                                 var path: String
    @Timestamp(key: T[4].0, on: .create, 
    format: .iso8601(withMilliseconds: true))           var createdAt: Date? 

    typealias REQ = User.REQ

    struct NEW: Content, Sendable {
        var name: String
        var data: Data
    }

    struct DTO: Content, Sendable { 
        var id: FileUpload.IDValue
        var name: String
        var path: String
        var createdAt: Date
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard let createDate = self.createdAt else { throw Abort(.badRequest, reason: "Wrong createAt value") }
        return try DTO(id: self.requireID() ,name: self.name, path: self.path, createdAt: createDate)
    }

    init() {}

    convenience init(userId: User.IDValue, path: String, data: NEW) throws {
        self.init(userId: userId, name: data.name, path: path)
    }

    init(
        userId: User.IDValue,
        name: String,
        path: String,
        createdAt: Date? = nil
    ) {
        self.id = nil
        self.$user.id = userId
        self.name = name
        self.path = path
        self.createdAt = createdAt
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = FileUpload }

}