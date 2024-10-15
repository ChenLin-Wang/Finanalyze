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
        ("contents", .array(of: .json), [.required], false), // [[String]]
        ("full_contents", .array(of: .json), [.required], false), // [[String]]
        ("created_at", .string, [.required], false),
        ("updated_at", .string, [.required], false),
    ]

    @ID(key: .id)                                       var id: UUID?
    @Parent(key: T[1].0)                                var user: User
    @Field(key: T[2].0)                                 var title: String
    @Field(key: T[3].0)                                 var preText: String?
    @Field(key: T[4].0)                                 var contents: [[String: String]]        // [{ role: string, content: string }]
    @Field(key: T[5].0)                                 var fullContents: [[String: String]]    // [{ role: string(maybe "system"), content: string }]
    @Timestamp(key: T[6].0, on: .create, 
    format: .iso8601(withMilliseconds: true))           var createdAt: Date?
    @Timestamp(key: T[7].0, on: .update, 
    format: .iso8601(withMilliseconds: true))           var updatedAt: Date?

    enum AnswerType: String, Codable { case text = "text"; case sql = "sql" }

    struct REQ: Content, Sendable {
        var id: AiChat.IDValue
    }

    struct QUES: Content, Sendable {
        var id: AiChat.IDValue
        var ques: String
    }

    struct ANS: Content, Sendable {
        var type: AnswerType
        var text: String?
        var sql: String?
    }

    struct NEW: Content, Sendable {
        var ques: String
    }

    struct TITLEANS: Content, Sendable {
        var title: String
    }

    struct DTO: Content, Sendable {
        var id: AiChat.IDValue
        var title: String
        var contents: [[String: String]]
        var createdAt: Date
        var updatedAt: Date
    }

    struct FEW: Content, Sendable {
        var id: AiChat.IDValue
        var title: String
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

    @Sendable func few(req: Request) async throws -> FEW { 
        guard
            let cDate = self.createdAt,
            let uDate = self.updatedAt
        else { throw Abort(.badRequest, reason: "Wrong date value") }
        return try FEW(id: self.requireID(), title: self.title, createdAt: cDate, updatedAt: uDate)
    }

    init() {}

    init(userId: User.IDValue, title: String, preText: String? = nil, contents: [[String: String]], fullContents: [[String: String]]) {
        self.id = nil
        self.$user.id = userId
        self.title = title
        self.preText = preText
        self.contents = contents
        self.fullContents = fullContents
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    struct MIG: DMigration, @unchecked Sendable { typealias MOD = AiChat }
}