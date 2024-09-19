// -- 令牌表，存储用户登录的会话信息
// -- Token table, stores user login token information
// CREATE TABLE sessions (
//     id SERIAL PRIMARY KEY,                       -- 令牌唯一标识符 / Token unique identifier
//     user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
//     token VARCHAR(255) NOT NULL,                 -- 会话令牌 / Token
//     expires_at TIMESTAMPTZ NOT NULL              -- 令牌过期时间 / Token expiration time
//     created_at TIMESTAMPTZ DEFAULT NOW(),        -- 令牌创建时间 / Token creation time
// );

import Vapor
import Fluent
import SQLKit

final class Token: DModel, @unchecked Sendable {
    static let schema = TableNames.tokens

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("token", .string, [.required], true),
        ("expires_at", .string, [.required], false),
        ("created_at", .string, [.required], false)
    ]

    @ID(key: .id)                                   var id: UUID?
    @Parent(key: T[1].0)                            var user: User
    @Field(key: T[2].0)                             var token: String
    @Timestamp(key: T[3].0, on: .none, 
    format: .iso8601(withMilliseconds: true))       var expiresAt: Date?
    @Timestamp(key: T[4].0, on: .none, 
    format: .iso8601(withMilliseconds: true))       var createdAt: Date?

    struct REQ: Content, Sendable {
        let user: User
    }

    struct DTO: Content, Sendable {
        let user: User
        let token: String
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        print(self.$user.id)
        try await self.$user.load(on: req.db)
        let d = DTO(user: self.user, token: self.token) 
        print("DTO INIT ")
        return d
    }

    init() {}

    init(userId: User.IDValue, token: String) {
        self.id = nil
        self.$user.id = userId
        self.token = token
        self.createdAt = .now
        self.expiresAt = self.createdAt?.addingTimeInterval(10080)  // 7 days
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = Token }
}

extension User {
    func generateToken() throws -> Token {
        let t = try Token(
            userId: self.requireID(),
            token: [UInt8].random(count: 16).base64
        )
        return t
    }
}