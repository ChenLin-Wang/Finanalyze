import Vapor
import Fluent

final class User: Model, @unchecked Sendable {
    static let schema = TableNames.users

    static let T: [FieldType] = [
        ("email", .string, [.required]),
        ("username", .string, []),
        ("password", .string, [.required]),
        ("is_active", .bool, []),
        ("is_verified", .bool, []),
        ("created_at", .date, []),
        ("updated_at", .date, []),
    ]
    
    @ID(key: .id)                               var id: UUID?
    @Field(key: T[0].0)                         var email: String
    @Field(key: T[1].0)                         var username: String?
    @Field(key: T[2].0)                         var passwordHash: String
    @Field(key: T[3].0)                         var isActive: Bool
    @Field(key: T[4].0)                         var isVerified: Bool
    @Timestamp(key: T[5].0, on: .create)        var createdAt: Date?
    @Timestamp(key: T[6].0, on: .update)        var updatedAt: Date?

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
