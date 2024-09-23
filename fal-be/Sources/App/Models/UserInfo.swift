import Vapor
import Fluent
import SQLKit

final class UserInfo: DModel, @unchecked Sendable {

    static let schema = TableNames.userInfos

    enum Gender: String, Codable { case male = "Male", female = "Female", none = "None"}

    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("user_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], true),
        ("username", .string, [.required], false),
        ("first_name", .string, [.required], false),
        ("middle_name", .string, [], false),
        ("last_name", .string, [.required], false),
        ("avatar", .string, [], false),
        ("age", .uint16, [], false),
        ("gender", .string, [.required], false),
        ("birthday", .date, [], false),
        ("address", .string, [], false),
        ("phone_number", .string, [], false),
        ("course", .string, [], false),
        ("year_lvl", .string, [], false),
        ("school", .string, [], false),
    ]

    @ID(key: .id)                                   var id: UUID?
    @Parent(key: T[1].0)                            var user: User
    @Field(key: T[2].0)                             var username: String
    @Field(key: T[3].0)                             var firstName: String
    @Field(key: T[4].0)                             var middleName: String?
    @Field(key: T[5].0)                             var lastName: String
    @Field(key: T[6].0)                             var avatar: String?
    @Field(key: T[7].0)                             var age: Int?
    @Field(key: T[8].0)                             var gender: String
    @Timestamp(key: T[9].0, on: .none,
    format: .default)                               var birthday: Date?
    @Field(key: T[10].0)                            var address: String?
    @Field(key: T[11].0)                            var phoneNum: String?
    @Field(key: T[12].0)                            var course: String?
    @Field(key: T[13].0)                            var yearLvl: String?
    @Field(key: T[14].0)                            var school: String?

    typealias REQ = User.REQ

    struct NEW: Content, Sendable {
        var userId: User.IDValue; var username: String; var firstName: String; var middleName: String?
        var lastName: String; var avatar: String?; var age: Int?; var gender: String; var _bday: String?
        var address: String?; var phoneNum: String?; var course: String?
        var yearLvl: String?; var school: String?;
    }
    
    struct DTO: Content, Sendable {
        var user: User.DTO; var username: String; var firstName: String; var middleName: String?
        var lastName: String; var avatar: String?; var age: Int?; var gender: Gender
        var birthday: Date?; var address: String?; var phoneNum: String?; var course: String?
        var yearLvl: String?; var school: String?
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        try await self.$user.load(on: req.db)
        guard let gender = Gender(rawValue: self.gender) else { throw Abort(.badRequest, reason: "Wrong gender value") }
        return try DTO(
            user: self.user.dto(req: req), username: self.username, firstName: self.firstName, middleName: self.middleName, 
            lastName: self.lastName, avatar: self.avatar, age: self.age, 
            gender: gender, birthday: self.birthday, 
            address: self.address, phoneNum: self.phoneNum, course: self.course, 
            yearLvl: self.yearLvl, school: self.school
        )
    }

    init() {}

    convenience init(data: NEW) throws {
        guard let gender = Gender(rawValue: data.gender) else { throw Abort(.badRequest, reason: "Wrong gender value") }
        self.init(
            userId: data.userId, username: data.username, firstName: data.firstName, lastName: data.lastName, middleName: data.middleName, 
            avatar: data.avatar, age: data.age, gender: gender, birthday: data._bday != nil ? ShortDateFormatter().date(from: data._bday!) : nil, 
            address: data.address, phoneNum: data.phoneNum, course: data.course, yearLvl: data.yearLvl, school: data.school
        )
    }

    init(
        userId: User.IDValue, username: String = RandomString(length: 12), firstName: String = "", lastName: String = "", middleName: String? = nil,
        avatar: String? = nil, age: Int? = nil, gender: Gender = .none, birthday: Date? = nil,
        address: String? = nil, phoneNum: String? = nil, course: String? = nil,
        yearLvl: String? = nil, school: String? = nil
    ) {
        self.id = nil
        self.username = username
        self.$user.id = userId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.avatar = avatar
        self.age = age
        self.gender = gender.rawValue
        self.birthday = birthday
        self.address = address
        self.phoneNum = phoneNum
        self.course = course
        self.yearLvl = yearLvl
        self.school = school
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = UserInfo }
}
