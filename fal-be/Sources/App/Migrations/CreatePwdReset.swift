import Fluent

struct CreatePwdReset: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        TableCreate(TableNames.pswReset, database: database, types: PswReset.T)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TableNames.pswReset).delete()
    }
}