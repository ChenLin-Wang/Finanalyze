import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        print("Hello world!")
        
        return "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
