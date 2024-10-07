import Vapor
import Fluent
import SQLKit

final class Transaction: DModel, @unchecked Sendable {
    static let schema = TableNames.transactions

    enum Category: String, Codable {
        case food = "food"
        case clothing = "clothing"
        case shelter = "shelter"
        case utilities = "utilities"
        case transportation = "transportation"
        case healthcare = "healthcare"
        case education = "education"
        case entertainment = "entertainment"
        case electronics = "electronics"
        case furniture = "furniture"
        case householdAppliances = "household_appliances"
        case personalCareProducts = "personal_care_products"
        case luxuryGoods = "luxury_goods"
        case sportsEquipment = "sports_equipment"
        case travel = "travel"
        case financialServices = "financial_services"
        case insurance = "insurance"
        case communicationDevices = "communication_devices"
        case subscriptionServices = "subscription_services"
        case booksAndMedia = "books_and_media"
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

    struct NEW: Content, Sendable { 
        var consumerId: User.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: String; var __transactionDate: String
    }
    
    struct DTO: Content, Sendable { 
        var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: Category; var transactionDate: Date
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard
            let category = Category(rawValue: self.category),
            let transactionDate = self.transactionDate
        else { throw Abort(.badRequest, reason: "Wrong category value") }
        return DTO(
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