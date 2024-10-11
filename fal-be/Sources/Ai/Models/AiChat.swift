import Vapor
import Fluent
import SQLKit

final class AiChat: DModel, @unchecked Sendable {
    static let schema = TableNames.aiChats

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("title", .string, [.required], false),
        ("pre_text", .string, [], false),
        ("contents", .array(of: .array(of: .string)), [.required], false), // [[String]]
        ("created_at", .string, [.required], false),
        ("updated_at", .string, [.required], false),
    ]

    @ID(key: .id)                                       var id: UUID?
    @Parent(key: T[1].0)                                var user: User
    @Field(key: T[2].0)                                 var title: String
    @Field(key: T[3].0)                                 var preText: String?
    @Field(key: T[4].0)                                 var contents: [[String]]
    @Timestamp(key: T[5].0, on: .create, 
    format: .iso8601(withMilliseconds: true))           var createdAt: Date?
    @Timestamp(key: T[6].0, on: .update, 
    format: .iso8601(withMilliseconds: true))           var updatedAt: Date?

    typealias REQ = User.REQ

    struct NEW: Content, Sendable {
        var title: String
        var preText: String?
        var contents: [[String]]
    }

    struct DTO: Content, Sendable {
        var id: UUID?
        var title: String
        var contents: [[String]]
        var createdAt: Date
        var updatedAt: Date
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard
            let cDate = self.createdAt,
            let uDate = self.updatedAt
        else { throw Abort(.badRequest, reason: "Wrong date value") }
        return try DTO(id: self.requireID(), title: self.title, contents: self.contents, createdAt: cDate, updatedAt: uDate)
    }

    init() {}

    convenience init(userId: User.IDValue, data: NEW) {
        self.init(userId: userId, title: data.title, preText: data.preText, contents: data.contents)
    }   

    init(userId: User.IDValue, title: String, preText: String? = nil, contents: [[String]]) {
        self.id = nil
        self.$user.id = userId
        self.title = title
        self.preText = preText
        self.contents = contents
        self.createdAt = nil
        self.updatedAt = nil
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = AiChat }

}