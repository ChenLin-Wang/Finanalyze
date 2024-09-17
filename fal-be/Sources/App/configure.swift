import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "admin",
                password: nil,
                database: "finanalyze",
                tls: .disable
            )
        ),
        as: .psql
    )
    try routes(app)
}
