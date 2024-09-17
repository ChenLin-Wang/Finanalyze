import Fluent

final class TableNames {
    static let users = "Users"
}

typealias FieldType = (FieldKey, DatabaseSchema.DataType, [DatabaseSchema.FieldConstraint])

func TableCreate(_ name: String, database: Database, types: [FieldType]) -> EventLoopFuture<Void> {
    var s = database.schema(name).id()
    for t in types {
        switch(t.2.count) {
            case 0: s = s.field(t.0, t.1)
            case 1: s = s.field(t.0, t.1, t.2[0])
            case 2: s = s.field(t.0, t.1, t.2[0], t.2[1])
            case 3: s = s.field(t.0, t.1, t.2[0], t.2[1], t.2[2])
            default: print("<\(name) - \(t.0)>: Too much db constraints")
        }
    }
    return s.create()
}