import Vapor
import Fluent
import SQLKit

final class Transaction: DModel, @unchecked Sendable {
    static let schema = TableNames.transactions

    enum Category: String, Codable, CaseIterable {
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
        ("total_price", .float, [.required], false),
        ("location", .string, [.required], false),
        ("brand", .string, [], false),
        ("category", .string, [.required], false),
        ("img", FileUpload.T[0].1, [.required, .references(FileUpload.schema, FileUpload.T[0].0)], false),
        ("transaction_date", .date, [.required], false),
    ]

    @ID(key: .id)                           var id: UUID?
    @Parent(key: T[1].0)                    var consumer: User
    @Field(key: T[2].0)                     var itemName: String
    @Field(key: T[3].0)                     var itemAmount: Int
    @Field(key: T[4].0)                     var pricePerUnit: Float
    @Field(key: T[5].0)                     var totalPrice: Float
    @Field(key: T[6].0)                     var location: String
    @Field(key: T[7].0)                     var brand: String?
    @Field(key: T[8].0)                     var category: String
    @Parent(key: T[9].0)                    var img: FileUpload
    @Timestamp(key: T[10].0, on: .none,
    format: .default)                       var transactionDate: Date?

    typealias REQ = User.REQ

    struct NEW: Content, Sendable { 
        var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: String; var __transactionDate: String; var imgPath: FileUpload.IDValue?
    }
    
    struct DTO: Content, Sendable { 
        var id: Transaction.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: Category; var transactionDate: Date; var imgPath: FileUpload.DTO?
    }

    struct ALLTRANSRES: Content, Sendable {
        let user: UserInfo.FEW
        let transaction: Transaction.DTO
    }

    @Sendable func dto(req: Request) async throws -> DTO { 
        guard
            let category = Category(rawValue: self.category),
            let transactionDate = self.transactionDate
        else { throw Abort(.badRequest, reason: "Wrong category value") }
        if (self.$img.id != FileUpload.nullID) { try await self.$img.load(on: req.db) }
        return try await DTO(
            id: self.requireID(),
            itemName: self.itemName,
            itemAmount: self.itemAmount,
            pricePerUnit: self.pricePerUnit,
            location: self.location,
            brand: self.brand,
            category: category,
            transactionDate: transactionDate,
            imgPath: self.$img.id == FileUpload.nullID ? nil : self.img.dto(req: req)
        )
    }

    init() {}

    convenience init(consumerId: User.IDValue, data: NEW) throws {
        guard let category = Category(rawValue: data.category) else { throw Abort(.badRequest, reason: "Wrong category value") }
        self.init(
            consumerId: consumerId,
            itemName: data.itemName,
            itemAmount: data.itemAmount,
            pricePerUnit: data.pricePerUnit,
            location: data.location,
            brand: data.brand,
            category: category,
            transactionDate: ShortDateFormatter().date(from: data.__transactionDate),
            img: data.imgPath ?? FileUpload.nullID
        )
    }

    init( 
        consumerId: User.IDValue, itemName: String, itemAmount: Int, pricePerUnit: Float, 
        location: String, brand: String? = nil, category: Category, transactionDate: Date?, img: FileUpload.IDValue
    ) {
        self.id = nil
        self.$consumer.id = consumerId
        self.itemName = itemName
        self.itemAmount = itemAmount
        self.pricePerUnit = pricePerUnit
        self.totalPrice = pricePerUnit * Float(itemAmount)
        self.location = location
        self.brand = brand
        self.category = category.rawValue
        self.$img.id = img
        self.transactionDate = transactionDate
    }

    struct MIG: DMigration, @unchecked Sendable { typealias MOD = Transaction }
}

extension Transaction {
    struct DEL: Content, Sendable { var id: UUID }

    struct UPD: Content, Sendable {
        var id: Transaction.IDValue; var itemName: String; var itemAmount: Int; 
        var pricePerUnit: Float; var location: String; var brand: String?; 
        var category: String; var __transactionDate: String; var imgPath: FileUpload.IDValue?
    }

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
            transactionDate: ShortDateFormatter().date(from: data.__transactionDate),
            img: data.imgPath ?? FileUpload.nullID
        )
    }
}

extension Transaction {
    enum FilterType: String, Codable {
        case itemName = "item_name"
        case itemPrice = "item_price"
        case itemAmount = "item_amount"
        case brand = "item_brand"
        case itemTotalPrice = "item_total_price"
        case category = "category"
        case date = "date"
        case user = "username"
        case email = "email"
    }

    enum CompareRelas: String, Codable {
        case equal = "equal"
        case notEqual = "not_equal"
        case prefix = "prefix"
        case suffix = "suffix"
        case contains = "contains"
        case notPrefix = "not_prefix"
        case notSuffix = "not_suffix"
        case notContains = "not_contains"
        case greater = "greater"
        case less = "smaller"
        case greaterOrEqual = "greater_and_equal"
        case lessOrEqual = "smaller_and_equal"

        var compareMethod: DatabaseQuery.Filter.Method {
            switch(self) {
                case .equal: return .equal
                case .notEqual: return .notEqual
                case .prefix: return .contains(inverse: false, .prefix)
                case .suffix: return .contains(inverse: false, .suffix)
                case .contains: return .contains(inverse: false, .anywhere)
                case .notPrefix: return .contains(inverse: true, .prefix)
                case .notSuffix: return .contains(inverse: true, .suffix)
                case .notContains: return .contains(inverse: true, .anywhere)
                case .greater: return .greaterThan
                case .less: return .lessThan
                case .greaterOrEqual: return .greaterThanOrEqual
                case .lessOrEqual: return .lessThanOrEqual
            }
        }
    }
    struct COUNTER: Content, Sendable { var filter: String; }
    struct FILTER: Content, Sendable { var filter: String; var sortBy: String; var sortDescending: Int }
}

extension QueryBuilder where Model == Transaction {
    func filter(str: String) throws -> Self {
        guard str != "" else { return self }
        var cdb = self
        let rules = str.components(separatedBy: ";")
        for curRule in rules {
            let items = curRule.components(separatedBy: ",")
            guard 
                items.count == 3,
                let type = Transaction.FilterType(rawValue: items[0]),
                let method = Transaction.CompareRelas(rawValue: items[1])?.compareMethod
            else {
                throw Abort(.badRequest, reason: "Wrong Filter Format")
            }
            switch (type) {
                case .itemName: cdb = cdb.filter(\.$itemName, method, items[2])
                case .brand: cdb = cdb.filter(\.$brand, method, items[2])
                case .itemPrice: cdb = cdb.filter(\.$pricePerUnit, method, try guardVal{ Float(items[2]) })
                case .itemAmount: cdb = cdb.filter(\.$itemAmount, method, try guardVal{ Int(items[2]) })
                case .itemTotalPrice: cdb = cdb.filter(\.$totalPrice, method, try guardVal{ Float(items[2]) })
                case .category: cdb = cdb.filter(\.$category, method, try guardVal{ Transaction.Category(rawValue: items[2])?.rawValue })
                case .date: cdb = cdb.filter(\.$transactionDate, method, try guardVal{ ShortDateFormatter().date(from: items[2]) })
                case .user: cdb = cdb.filter(UserInfo.self, \.$username, method, items[2])
                case .email: cdb = cdb.filter(User.self, \.$email, method, items[2])
            }
        }

        func guardVal<T>(conversion: @escaping () -> T?) throws -> T {
            guard let res = conversion() else {throw Abort(.badRequest, reason: "Wrong Filter Format")}
            return res
        }

        return cdb
    }

    func sort(by str: String, descending: Int) throws -> Self {
        guard let type = Transaction.FilterType(rawValue: str) else { throw Abort(.badRequest, reason: "Wrong Sort Format") }
        let des = descending != 0
        switch (type) {
            case .itemName: return self.sort(\.$itemName, des ? .descending : .ascending)
            case .brand: return self.sort(\.$brand, des ? .descending : .ascending)
            case .itemPrice: return self.sort(\.$pricePerUnit, des ? .descending : .ascending)
            case .itemAmount: return self.sort(\.$itemAmount, des ? .descending : .ascending)
            case .itemTotalPrice: return self.sort(\.$totalPrice, des ? .descending : .ascending)
            case .category: return self.sort(\.$category, des ? .descending : .ascending)
            case .date: return self.sort(\.$transactionDate, des ? .descending : .ascending)
            case .user: return self.sort(UserInfo.self, \.$username, des ? .descending : .ascending)
            case .email: return self.sort(User.self, \.$email, des ? .descending : .ascending)
        }
    }
}