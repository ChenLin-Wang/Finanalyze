import Fluent
import SQLKit
import Vapor

final class TableNames {
    static let users = "users"
    static let pswReset = "password_resets"
    static let tokens = "tokens"
    static let userInfos = "user_infos"
    static let transactions = "transactions"
    static let fileUploads = "file_uploads"
    static let aiChats = "ai_chats"
}

typealias FieldType = (FieldKey, DatabaseSchema.DataType, [DatabaseSchema.FieldConstraint], Bool)

func Def(_ value: any SQLExpression) -> DatabaseSchema.FieldConstraint { .sql(.default(value)) }
func Def(_ value: String) -> DatabaseSchema.FieldConstraint { .sql(.default(value)) }
func Def<T: BinaryInteger>(_ value: T) -> DatabaseSchema.FieldConstraint { .sql(.default(value)) }
func Def<T: FloatingPoint>(_ value: T) -> DatabaseSchema.FieldConstraint { .sql(.default(value)) }
func Def(_ value: Bool) -> DatabaseSchema.FieldConstraint { .sql(.default(value)) }

func TableCreate(_ name: String, database: Database, types: [FieldType]) -> EventLoopFuture<Void> {
    var s = database.schema(name).id()
    var uniques: [FieldKey] = []
    for t in types {
        if t.0 == "id" { continue }
        if t.3 == true { uniques.append(t.0) }
        switch(t.2.count) {
            case 0: s = s.field(t.0, t.1)
            case 1: s = s.field(t.0, t.1, t.2[0])
            case 2: s = s.field(t.0, t.1, t.2[0], t.2[1])
            case 3: s = s.field(t.0, t.1, t.2[0], t.2[1], t.2[2])
            default: print("<\(name) - \(t.0)>: Too much field constraints")
        }
    }
    for unique in uniques { s = s.unique(on: unique) }
    return s.create()
}

protocol DModel: Model, AsyncResponseEncodable, Sendable {
    associatedtype NEW: Content & Sendable
    associatedtype REQ: Content & Sendable
    associatedtype DTO: Content & Sendable
    associatedtype MIG: DMigration
    static var T: [FieldType] {get}
    @Sendable func dto(req: Request) async throws -> DTO
    // @Sendable func dtos(from models: [Self], req: Request) async throws -> [DTO]
}

extension DModel {
    @Sendable public func encodeResponse(for request: Request) async throws -> Response {
        let dto = try await self.dto(req: request)
        return try await dto.encodeResponse(for: request)
    }
}

protocol DMigration: Migration, Sendable {
    associatedtype MOD: DModel
}

extension DMigration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        TableCreate(MOD.schema, database: database, types: MOD.T)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(MOD.schema).delete()
    }
}

extension Array {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async throws -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}

extension Array where Element: DModel {
    @Sendable func dtos(req: Request) async throws -> [Element.DTO] {
        try await self.asyncMap { try await $0.dto(req: req) }
    }
}