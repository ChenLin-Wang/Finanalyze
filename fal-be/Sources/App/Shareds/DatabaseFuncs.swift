import Fluent
import SQLKit

final class TableNames {
    static let users = "users"
    static let pswReset = "password_reset"
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
    switch(uniques.count) {
        case 0: break
        case 1: s = s.unique(on: uniques[0])
        case 2: s = s.unique(on: uniques[0], uniques[1])
        case 3: s = s.unique(on: uniques[0], uniques[1], uniques[2])
        case 4: s = s.unique(on: uniques[0], uniques[1], uniques[2], uniques[3])
        default: print("<\(name)>: Too much db unique field constraints")
    }
    return s.create()
}