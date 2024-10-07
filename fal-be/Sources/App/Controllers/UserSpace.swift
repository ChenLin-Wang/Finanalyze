import Vapor
import Fluent
import MultipartKit

struct UserSpace: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userRoute = routes.grouped("user")
        let infoRoute = userRoute.grouped("info")
        infoRoute.get(use: getInfos)
        infoRoute.post(use: updateInfos)
        let transactionRoute = userRoute.grouped("transactions")
        transactionRoute.get(use: getTransactions)
        transactionRoute.post(use: updateTransaction)
        transactionRoute.post("new", use: newTransaction)
        let uploadRoute = userRoute.grouped("upload")
        uploadRoute.on(.GET, body: .collect(maxSize: "100mb"), use: getFileList)
        uploadRoute.on(.POST, body: .collect(maxSize: "100mb"), use: uploadFile)
    }
    
    @Sendable func getInfos(req: Request) async throws -> UserInfo {
        let user = try req.auth.require(User.self)
        guard let infos = try await UserInfo.query(on: req.db).filter(\.$user.$id == user.requireID()).first()  else {
            throw Abort(.notFound, reason: "User not found")
        }
        return infos
    }

    @Sendable func updateInfos(req: Request) async throws -> UserInfo {
        try req.auth.require(User.self)
        let createDatas = try req.content.decode(UserInfo.NEW.self)
        let infos: UserInfo = try UserInfo(data: createDatas)
        try await UserInfo.query(on: req.db)
            .set([
                UserInfo.T[2].0: .bind(infos.username),
                UserInfo.T[3].0: .bind(infos.firstName),
                UserInfo.T[4].0: .bind(infos.middleName),
                UserInfo.T[5].0: .bind(infos.lastName),
                UserInfo.T[6].0: .bind(infos.avatar),
                UserInfo.T[7].0: .bind(infos.age),
                UserInfo.T[8].0: .bind(infos.gender),
                UserInfo.T[9].0: .bind(infos.birthday),
                UserInfo.T[10].0: .bind(infos.address),
                UserInfo.T[11].0: .bind(infos.phoneNum),
                UserInfo.T[12].0: .bind(infos.course),
                UserInfo.T[13].0: .bind(infos.yearLvl),
                UserInfo.T[14].0: .bind(infos.school),
            ])
            .filter(\.$user.$id == infos.$user.id).update()
        return infos
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

    @Sendable func getFileList(req: Request) async throws -> [FileUpload.DTO] {
        let user = try req.auth.require(User.self)
        let files = try await FileUpload.query(on: req.db).filter(\.$user.$id == user.requireID()).all()
        return try await files.dtos(req: req)
    }

    @Sendable func uploadFile(req: Request) async throws -> FileUpload {
        let user = try req.auth.require(User.self)
        let directory = DirectoryConfiguration.detect().workingDirectory + "Public/uploads/"
        let file = try req.content.decode(FileUpload.NEW.self)
        let realName = RandomTimeBasedName() + "_" + file.name 
        let path = directory + realName
        let fileData = try FileUpload(userId: user.requireID(), path: "https://api.finanalyze.inspiral.site/uploads/" + realName, data: file)
        try file.data.write(to: URL(fileURLWithPath: path))
        try await fileData.save(on: req.db)
        return fileData
    }

}