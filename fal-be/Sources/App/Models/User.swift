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

/*
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
*/

import Vapor
import Fluent
import SQLKit

final class User: DModel, @unchecked Sendable {
    static let schema = TableNames.users

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("email", .string, [.required], true),
        ("password", .string, [.required], false),
        ("is_active", .bool, [.required, Def(true)], false),
        ("is_verified", .bool, [.required, Def(false)], false),
        ("created_at", .string, [.required], false),
        ("updated_at", .string, [.required], false),
    ]
    
    @ID(key: .id)                                               var id: UUID?
    @Field(key: T[1].0)                                         var email: String
    @Field(key: T[2].0)                                         var passwordHash: String
    @Field(key: T[3].0)                                         var isActive: Bool
    @Field(key: T[4].0)                                         var isVerified: Bool
    @Timestamp(key: T[5].0, on: .create, 
    format: .iso8601(withMilliseconds: true))                   var createdAt: Date?             
    @Timestamp(key: T[6].0, on: .update, 
    format: .iso8601(withMilliseconds: true))                   var updatedAt: Date?

    struct NEW: Content, Sendable {
        let email: String
        let password: String
    }

    struct REQ: Content, Sendable {
        let userId: User.IDValue
    }

    struct DTO: Content, Sendable {
        let id: User.IDValue
        let email: String
    }

    @Sendable func dto(req: Request) throws -> DTO { DTO(id: try self.requireID(), email: self.email) }

    init() {}

    convenience init(data: NEW) throws { self.init(email: data.email, passwordHash: try Bcrypt.hash(data.password)) }

    init(email: String, passwordHash: String) {
        self.id = nil
        self.email = email
        self.passwordHash = passwordHash
        self.createdAt = nil
        self.updatedAt = nil
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = User }

}

extension User.DTO: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}