import Vapor
import Fluent

struct TransactionC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let transactionRoute = routes.grouped("transactions")
        transactionRoute.get(use: getTransactions)
        transactionRoute.post(use: updateTransaction)
        transactionRoute.post("new", use: newTransaction)
    }

        @Sendable func getTransactions(req: Request) async throws -> [Transaction.DTO] {
        let user = try req.auth.require(User.self)
        let transactions = try await Transaction.query(on: req.db).filter(\.$consumer.$id == user.requireID()).all()
        return try await transactions.dtos(req: req)
    }

    @Sendable func newTransaction(req: Request) async throws -> Transaction {
        try req.auth.require(User.self)
        let transactionDatas = try req.content.decode(Transaction.NEW.self)
        let transaction = try Transaction(data: transactionDatas)
        try await transaction.save(on: req.db)
        return transaction
    }

    @Sendable func updateTransaction(req: Request) async throws -> Transaction {
        try req.auth.require(User.self)
        let transactionDatas = try req.content.decode(Transaction.NEW.self)
        let transaction = try Transaction(data: transactionDatas)
        try await Transaction.query(on: req.db)
            .set([
                Transaction.T[2].0: .bind(transaction.itemName),
                Transaction.T[3].0: .bind(transaction.itemAmount),
                Transaction.T[4].0: .bind(transaction.pricePerUnit),
                Transaction.T[5].0: .bind(transaction.location),
                Transaction.T[6].0: .bind(transaction.brand),
                Transaction.T[7].0: .bind(transaction.category),
                Transaction.T[8].0: .bind(transaction.transactionDate),
            ])
            .filter(\.$consumer.$id == transaction.$consumer.id).update()
        return transaction
    }
}