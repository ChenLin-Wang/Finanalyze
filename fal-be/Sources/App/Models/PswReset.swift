// -- 密码重置表，处理忘记密码的情况
// -- Password reset table, handles forgotten password requests
// CREATE TABLE password_resets (
//     id SERIAL PRIMARY KEY,                       -- 密码重置请求唯一标识符 / Password reset request unique identifier
//     user_id INTEGER REFERENCES users(id),        -- 关联到用户表的外键 / Foreign key to users table
//     reset_token VARCHAR(255) NOT NULL,           -- 重置令牌 / Reset token
//     expires_at TIMESTAMPTZ NOT NULL,             -- 重置令牌的过期时间 / Reset token expiration time
//     created_at TIMESTAMPTZ DEFAULT NOW()         -- 请求创建时间 / Request creation time
// );

import Vapor
import Fluent
import SQLKit

final class PswReset: Model, @unchecked Sendable {
    static let schema = TableNames.pswReset

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("reset_token", .string, [.required], false),
        ("expires_at", .date, [.required], false),
        ("created_at", .date, [.required, Def(SQLFunction("NOW"))], false)
    ]

    @ID(key: .id)                   var id: UUID?
    @Parent(key: T[1].0)            var user: User
    @Field(key: T[2].0)             var resetToken: String
    @Field(key: T[3].0)             var expiresAt: Date?
    @Field(key: T[4].0)             var createdAt: Date?

    init() {}

    init(id: UUID? = nil, userId: UUID, resetToken: String) {
        self.id = id
        self.$user.id = userId
        self.resetToken = resetToken
        self.createdAt = .now
        self.expiresAt = self.createdAt?.addingTimeInterval(10080)  // 7 days
    }
}