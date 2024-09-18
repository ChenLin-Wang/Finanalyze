import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        return "Your name: " + ((try? req.query.get(String.self, at: "name")) ?? "nil")
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
