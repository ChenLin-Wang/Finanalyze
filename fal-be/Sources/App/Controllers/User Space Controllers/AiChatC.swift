import Vapor
import Fluent
import FluentPostgresDriver

struct AiChatC: RouteCollection {

    static let AIQuestionURI = URI("http://localhost:4773/chat")
    static let AIDatabaseTitleURI = URI("http://localhost:4773/chat/title")
    static let AIDatabaseSqlURI = URI("http://localhost:4773/chat/sql")

    func boot(routes: RoutesBuilder) throws {
        let aiRoute = routes.grouped("ai")
        aiRoute.get(use: getChats)
        let aiChatRoute = aiRoute.grouped("chat")
        aiChatRoute.get(use: getChats)
        aiChatRoute.put(use: newChat)
        aiChatRoute.post(use: sendQues)
    }

    @Sendable func getChats(req: Request) async throws -> [AiChat.FEW] {
        let user = try req.auth.require(User.self)
        let chats = try await AiChat.query(on: req.db).filter(\.$user.$id == user.requireID()).sort(\.$updatedAt, .ascending).all()
        return try await chats.asyncMap { try await $0.few(req: req) }
    }

    @Sendable func newChat(req: Request) async throws -> AiChat {
        let user = try req.auth.require(User.self)
        let newDatas = try req.content.decode(AiChat.NEW.self)
        let title = try await titleAi(req: req, ques: newDatas.ques)
        let chat = try AiChat(userId: user.requireID(), title: title, preText: "This user's ID is \"\(user.requireID())\", you can use it for future query in sql database, but never show it to the user.", contents: [], fullContents: [])
        try await chat.save(on: req.db)
        return chat
    }

    @Sendable func getChatContent(req: Request) async throws -> AiChat {
        let user = try req.auth.require(User.self)
        let datas = try req.query.decode(AiChat.REQ.self)
        guard 
            let chat = try await AiChat.query(on: req.db).filter(\.$id == datas.id).filter(\.$user.$id == user.requireID()).first()
        else { throw Abort(.badRequest, reason: "Chat not found") }
        return chat
    }

    @Sendable func sendQues(req: Request) async throws -> String {
        let user = try req.auth.require(User.self)
        let ques = try req.content.decode(AiChat.QUES.self)
        guard 
            let chat = try await AiChat.query(on: req.db).filter(\.$id == ques.id).filter(\.$user.$id == user.requireID()).first()
        else { throw Abort(.badRequest, reason: "Chat not found") }
        chat.fullContents.append(["role": "user", "content": ques.ques])
        let ans = try await chatAi(req: req, ques: ques.ques, originQues: ques.ques, url: Self.AIQuestionURI, chat: chat)
        try await chat.save(on: req.db)
        return ans
    }

    func titleAi(req: Request, ques: String) async throws -> String {
        let answer = try await req.client.post(Self.AIDatabaseTitleURI) { clientRequest in
            clientRequest.headers.contentType = .json
            clientRequest.body = .init(data: try JSONSerialization.data(withJSONObject: ["ques": ques]))
        }
        guard answer.status == .ok else { throw Abort(.internalServerError) }
        return try answer.content.decode(AiChat.TITLEANS.self).title
    }

    func chatAi(req: Request, ques: String, originQues: String, url: URI, chat: AiChat) async throws -> String {
        guard let preText = chat.preText else { throw Abort(.internalServerError) }
        let answer = try await req.client.post(url) { clientRequest in
            clientRequest.headers.contentType = .json
            clientRequest.body = .init(data: try JSONSerialization.data(withJSONObject: ["prompts":["content": ques], "histories": [["role": "user", "content": preText]] + chat.fullContents]))
        }
        guard answer.status == .ok else { throw Abort(.internalServerError) }
        let ans = try answer.content.decode(AiChat.ANS.self)
        switch(ans.type) {
            case .text:
                guard let txt = ans.text else { throw Abort(.internalServerError) }
                chat.contents.append(["role": "user", "content": originQues])
                chat.fullContents.append(["role": "user", "content": ques])
                chat.contents.append(["role": "model", "content": txt])
                chat.fullContents.append(["role": "model", "content": txt])
                return txt
            case .sql:
                guard 
                    let sql = ans.sql,
                    let sqlDB = req.db as? PostgresDatabase
                else { throw Abort(.internalServerError) }
                let query = try await sqlDB.simpleQuery(sql).get()
                let sqlRes = query.description
                chat.fullContents.append(["role": "model", "content": sql])
                chat.fullContents.append(["role": "user", "content": sqlRes])
                return try await chatAi(req: req, ques: sqlRes, originQues:ques , url: Self.AIDatabaseSqlURI, chat: chat)
        }
    }
}