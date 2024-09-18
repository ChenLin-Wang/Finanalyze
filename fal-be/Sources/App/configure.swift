import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    app.http.server.configuration.port = 1511
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "vapor",
                password: "159753",
                database: "finanalyze",
                tls: .disable
            )
        ),
        as: .psql
    )
    app.migrations.add(CreateUser())
    app.migrations.add(CreatePwdReset())
    app.migrations.add(CreateSession())
    // app.logger.logLevel = .debug
    try await app.autoMigrate()
    try routes(app)
}
