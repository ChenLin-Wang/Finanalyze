import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        TableCreate(TableNames.users, database: database, types: User.T)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TableNames.users).delete()
    }
}

