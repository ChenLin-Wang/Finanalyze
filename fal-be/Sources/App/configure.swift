import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    app.http.server.configuration.port = 1511
    app.http.server.configuration.hostname = "0.0.0.0"
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

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )

    let cors = CORSMiddleware(configuration: corsConfiguration)
    let error = ErrorMiddleware.default(environment: app.environment)
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(cors)
    app.middleware.use(error)

    // app.sessions.use(.fluent)

    app.migrations.add(User.MIG())
    app.migrations.add(PswReset.MIG())
    app.migrations.add(Token.MIG())
    app.migrations.add(UserInfo.MIG())
    app.migrations.add(Transaction.MIG())
    app.migrations.add(FileUpload.MIG())
    app.migrations.add(AiChat.MIG())
    
    // app.logger.logLevel = .debug
    try await app.autoMigrate()
    try routes(app)
}
