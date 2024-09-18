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

final class PswReset: DModel, @unchecked Sendable {
    static let schema = TableNames.pswReset

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("reset_token", .string, [.required], false),
        ("expires_at", .string, [.required], false),
        ("created_at", .string, [.required], false)
    ]

    @ID(key: .id)                                   var id: UUID?
    @Parent(key: T[1].0)                            var user: User
    @Field(key: T[2].0)                             var resetToken: String
    @Timestamp(key: T[3].0, on: .none, 
    format: .iso8601(withMilliseconds: true))       var expiresAt: Date?
    @Timestamp(key: T[4].0, on: .none, 
    format: .iso8601(withMilliseconds: true))       var createdAt: Date?

    typealias DTO = REQ

    struct REQ: Content, Sendable {
        let user: User
        let resetToken: String
    }

    @Sendable func dto(req: Request) -> DTO { DTO(user: self.user, resetToken: self.resetToken) }

    init() {}

    init(userId: UUID, resetToken: String) {
        self.id = nil
        self.$user.id = userId
        self.resetToken = resetToken
        self.createdAt = .now
        self.expiresAt = self.createdAt?.addingTimeInterval(10080)  // 7 days
    }
}