import Fluent

struct CreateSession: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        TableCreate(TableNames.sessions, database: database, types: Session.T)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TableNames.sessions).delete()
    }
}

