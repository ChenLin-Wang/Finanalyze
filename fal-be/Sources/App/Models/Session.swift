// -- 会话表，存储用户登录的会话信息
// -- Sessions table, stores user login session information
// CREATE TABLE sessions (
//     id SERIAL PRIMARY KEY,                       -- 会话唯一标识符 / Session unique identifier
//     user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
//     session_token VARCHAR(255) NOT NULL,         -- 会话令牌 / Session token
//     expires_at TIMESTAMPTZ NOT NULL              -- 会话过期时间 / Session expiration time
//     created_at TIMESTAMPTZ DEFAULT NOW(),        -- 会话创建时间 / Session creation time
// );

import Vapor
import Fluent
import SQLKit

final class Session: Model, @unchecked Sendable {
    static let schema = TableNames.sessions

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("session_token", .string, [.required], false),
        ("expires_at", .date, [.required], false),
        ("created_at", .date, [.required, Def(SQLFunction("NOW"))], false)
    ]

    @ID(key: .id)                   var id: UUID?
    @Parent(key: T[1].0)            var user: User
    @Field(key: T[2].0)             var sessionToken: String
    @Field(key: T[3].0)             var expiresAt: Date?
    @Field(key: T[4].0)             var createdAt: Date?

    init() {}

    init(id: UUID? = nil, userId: UUID, sessionToken: String) {
        self.id = id
        self.$user.id = userId
        self.sessionToken = sessionToken
        self.createdAt = .now
        self.expiresAt = self.createdAt?.addingTimeInterval(10080)  // 7 days
    }
}