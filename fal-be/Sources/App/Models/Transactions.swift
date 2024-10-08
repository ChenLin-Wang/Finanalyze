import Vapor
import Fluent
import SQLKit

final class Transaction: DModel, @unchecked Sendable {
    static let schema = TableNames.transactions

    enum Category: String, Codable {
        case food = "Food"
        case clothing = "Clothing"
        case shelter = "Shelter"
        case utilities = "Utilities"
        case transportation = "Transportation"
        case healthcare = "Healthcare"
        case education = "Education"
        case entertainment = "Entertainment"
        case electronics = "Electronics"
        case furniture = "Furniture"
        case householdAppliances = "Household Appliances"
        case personalCareProducts = "Personal Care Products"
        case luxuryGoods = "Luxury Goods"
        case sportsEquipment = "Sports Equipment"
        case travel = "Travel"
        case financialServices = "Financial Services"
        case insurance = "Insurance"
        case communicationDevices = "Communication Devices"
        case subscriptionServices = "Subscription Services"
        case booksAndMedia = "Books and Media"
    }

    // number | item name | amount | price per unit | location | brand
    static let T: [FieldType] = [
        ("id", .uuid, [.required], true),
        ("consumer_id", User.T[0].1, [.required, .references(User.schema, User.T[0].0)], false),
        ("item_name", .string, [.required], false),
        ("item_amount", .uint16, [.required], false),
        ("price_per_unit", .float, [.required], false),
        ("location", .string, [.required], false),
        ("brand", .string, [], false),
        ("category", .string, [.required], false),
        ("transaction_date", .date, [.required], false),
    ]

    @ID(key: .id)                           var id: UUID?
    @Parent(key: T[1].0)                    var consumer: User
    @Field(key: T[2].0)                     var itemName: String
    @Field(key: T[3].0)                     var itemAmount: Int
    @Field(key: T[4].0)                     var pricePerUnit: Float
    @Field(key: T[5].0)                     var location: String
    @Field(key: T[6].0)                     var brand: String?
    @Field(key: T[7].0)                     var category: String
    @Timestamp(key: T[8].0, on: .none,
    format: .default)                       var transactionDate: Date?

    typealias REQ = User.REQ

    struct DEL: Content, Sendable { var id: UUID }

    struct UPD: Content, Sendable {
        var id: Transaction.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: String; var __transactionDate: String
    }

    struct NEW: Content, Sendable { 
        var consumerId: User.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: String; var __transactionDate: String
    }
    
    struct DTO: Content, Sendable { 
        var id: Transaction.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: Category; var transactionDate: Date
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard
            let category = Category(rawValue: self.category),
            let transactionDate = self.transactionDate
        else { throw Abort(.badRequest, reason: "Wrong category value") }
        return try DTO(
            id: self.requireID(),
            itemName: self.itemName,
            itemAmount: self.itemAmount,
            pricePerUnit: self.pricePerUnit,
            location: self.location,
            brand: self.brand,
            category: category,
            transactionDate: transactionDate
        )
    }

    init() {}

    convenience init(consumerId: Transaction.IDValue, data: UPD) throws {
        guard let category = Category(rawValue: data.category) else { throw Abort(.badRequest, reason: "Wrong category value") }
        self.init(
            consumerId: consumerId,
            itemName: data.itemName,
            itemAmount: data.itemAmount,
            pricePerUnit: data.pricePerUnit,
            location: data.location,
            brand: data.brand,
            category: category,
            transactionDate: ShortDateFormatter().date(from: data.__transactionDate)
        )
    }

    convenience init(data: NEW) throws {
        guard let category = Category(rawValue: data.category) else { throw Abort(.badRequest, reason: "Wrong category value") }
        self.init(
            consumerId: data.consumerId,
            itemName: data.itemName,
            itemAmount: data.itemAmount,
            pricePerUnit: data.pricePerUnit,
            location: data.location,
            brand: data.brand,
            category: category,
            transactionDate: ShortDateFormatter().date(from: data.__transactionDate)
        )
    }

    init( 
        consumerId: User.IDValue, itemName: String, itemAmount: Int, pricePerUnit: Float, 
        location: String, brand: String? = nil, category: Category, transactionDate: Date?
    ) {
        self.id = nil
        self.$consumer.id = consumerId
        self.itemName = itemName
        self.itemAmount = itemAmount
        self.pricePerUnit = pricePerUnit
        self.location = location
        self.brand = brand
        self.category = category.rawValue
        self.transactionDate = transactionDate
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = Transaction }
}