// -- 用户表，存储基础的用户信息
// -- User table, stores basic user information
// CREATE TABLE users (
//     id SERIAL PRIMARY KEY,                       -- 用户唯一标识符 / User unique identifier
//     email VARCHAR(255) NOT NULL UNIQUE,          -- 用户邮箱，必须唯一 / User email, must be unique
//     username VARCHAR(255),                       -- 用户名，非必需 / Username, optional
//     password_hash VARCHAR(255) NOT NULL,         -- 加密后的密码哈希 / Hashed password
//     is_active BOOLEAN DEFAULT TRUE,              -- 账户是否激活 / Whether the account is active
//     is_verified BOOLEAN DEFAULT FALSE            -- 是否通过验证 / Whether the account is verified
//     created_at TIMESTAMPTZ DEFAULT NOW(),        -- 用户创建时间 / User account creation time
//     updated_at TIMESTAMPTZ DEFAULT NOW(),        -- 账户最后更新时间 / Last account update time
// );

import Vapor
import Fluent
import SQLKit

final class User: Model, @unchecked Sendable {
    static let schema = TableNames.users

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("email", .string, [.required], true),
        ("username", .string, [.required, Def(RandomString(length: 12))], false),
        ("password", .string, [.required], false),
        ("is_active", .bool, [.required, Def(true)], false),
        ("is_verified", .bool, [.required, Def(false)], false),
        ("created_at", .date, [.required, Def(SQLFunction("NOW"))], false),
        ("updated_at", .date, [.required, Def(SQLFunction("NOW"))], false),
    ]
    
    @ID(key: .id)                                               var id: UUID?
    @Field(key: T[1].0)                                         var email: String
    @Field(key: T[2].0)                                         var username: String?
    @Field(key: T[3].0)                                         var passwordHash: String
    @Field(key: T[4].0)                                         var isActive: Bool
    @Field(key: T[5].0)                                         var isVerified: Bool
    @Timestamp(key: T[6].0, on: .create, format: .iso8601)      var createdAt: Date?
    @Timestamp(key: T[7].0, on: .update, format: .iso8601)      var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, email: String, username: String?, passwordHash: String, isActive: Bool = true, isVerified: Bool = false) {
        self.id = id
        self.email = email
        self.username = username
        self.passwordHash = passwordHash
        self.isActive = isActive
        self.isVerified = isVerified
    }
}
