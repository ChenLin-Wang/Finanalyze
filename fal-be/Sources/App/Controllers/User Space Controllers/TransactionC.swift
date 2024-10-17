import Vapor
import Fluent

struct TransactionC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let transactionRoute = routes.grouped("transactions")
        transactionRoute.get("count", use: getTransactionCount)
        transactionRoute.get("all", use: getAllTransactions)
        transactionRoute.put(use: newTransaction)
        transactionRoute.get(use: getTransactions)
        transactionRoute.post(use: updateTransaction)
        transactionRoute.delete(use: deleteTransaction)
    }

    @Sendable func getTransactionCount(req: Request) async throws -> Int {
        let user = try req.auth.require(User.self)
        let filter = try req.query.decode(Transaction.COUNTER.self).filter
        let count = try await Transaction.query(on: req.db)
            .filter(\.$consumer.$id == user.requireID())
            .filter(str: filter)
            .count()
        return count
    }

    @Sendable func getTransactions(req: Request) async throws -> [Transaction.DTO] {
        let user = try req.auth.require(User.self)
        let filter = try req.query.decode(Transaction.FILTER.self)
        let transactions = try await Transaction.query(on: req.db)
            .filter(\.$consumer.$id == user.requireID())
            .filter(str: filter.filter)
            .sort(by: filter.sortBy, descending: filter.sortDescending)
            .paginate(for: req).items
            as [Transaction]
        return try await transactions.dtos(req: req)
    }
    
    struct ALLTRANSRES: Content, Sendable {
        let user: UserInfo.FEW
        let transactions: [Transaction.DTO]
    }

    @Sendable func getAllTransactions(req: Request) async throws -> [ALLTRANSRES] {
        try req.auth.require(User.self)
        let filter = try req.query.decode(Transaction.FILTER.self)
        let userInfos = try await UserInfo.query(on: req.db).join(User.self, on: \UserInfo.$user.$id == \User.$id).all().asyncMap { ui async throws -> ALLTRANSRES in
            ALLTRANSRES(
                user: try UserInfo.FEW(email: ui.joined(User.self).email, username: ui.username),
                transactions: try await Transaction.query(on: req.db)
                    .filter(\.$consumer.$id == ui.joined(User.self).requireID())
                    .filter(str: filter.filter)
                    .sort(by: filter.sortBy, descending: filter.sortDescending)
                    .paginate(for: req).items
                    .dtos(req: req)
            )
        }
        return userInfos
    }

    @Sendable func newTransaction(req: Request) async throws -> Transaction {
        try req.auth.require(User.self)
        let transactionDatas = try req.content.decode(Transaction.NEW.self)
        let transaction = try Transaction(data: transactionDatas)
        try await transaction.save(on: req.db)
        return transaction
    }

    @Sendable func updateTransaction(req: Request) async throws -> Response {
        let user = try req.auth.require(User.self)
        let transactionDatas = try req.content.decode(Transaction.UPD.self)
        try await Transaction.query(on: req.db)
            .set([
                Transaction.T[2].0: .bind(transactionDatas.itemName),
                Transaction.T[3].0: .bind(transactionDatas.itemAmount),
                Transaction.T[4].0: .bind(transactionDatas.pricePerUnit),
                Transaction.T[5].0: .bind(Float(transactionDatas.itemAmount) * transactionDatas.pricePerUnit),
                Transaction.T[6].0: .bind(transactionDatas.location),
                Transaction.T[7].0: .bind(transactionDatas.brand),
                Transaction.T[8].0: .bind(transactionDatas.category),
                Transaction.T[9].0: .bind(ShortDateFormatter().date(from: transactionDatas.__transactionDate)),
            ])
            .filter(\.$consumer.$id == user.requireID())
            .filter(\.$id == transactionDatas.id)
            .update()
        return Response(status: .ok)
    }

    @Sendable func deleteTransaction(req: Request) async throws -> Response {
        let user = try req.auth.require(User.self)
        let delData = try req.content.decode(Transaction.DEL.self)
        try await Transaction.query(on: req.db)
            .filter(\.$consumer.$id == user.requireID())
            .filter(\.$id == delData.id)
            .delete()
        return Response(status: .ok)
    }
}