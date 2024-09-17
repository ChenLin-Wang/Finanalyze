import Vapor
import Fluent

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)                                   var id: UUID?
    @Field(key: "email")                            var email: String
    @Field(key: "username")                         var username: String?
    @Field(key: "password")                         var passwordHash: String
    @Field(key: "is_active")                        var isActive: Bool
    @Field(key: "is_verified")                      var isVerified: Bool
    @Timestamp(key: "created_at", on: .create)      var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)      var updatedAt: Date?

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
