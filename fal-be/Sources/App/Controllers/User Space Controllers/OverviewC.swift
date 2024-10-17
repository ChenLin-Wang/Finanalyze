import Vapor
import Fluent
import FluentPostgresDriver

struct OverviewC: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let overviewRoute = routes.grouped("overview")
        overviewRoute.get("summary", use: summaries)
        overviewRoute.get("timeline", use: timeLineFreqs)
        overviewRoute.get("category", use: categoryFreqs)
        overviewRoute.get("item", use: itemFreqs)
    }

    @Sendable func summaries(req: Request) async throws -> Overview.SummaryOUT {
        let user = try req.auth.require(User.self)
        let totalRes = try await (req.db as! PostgresDatabase).query("""
            SELECT COUNT(*) AS count, SUM(total_price) AS cost
            FROM transactions
            WHERE consumer_id = '\(user.requireID())'
        """).get()[0].datas()

        let monthlyRes = try await getTimeLineFreqs(
            data: .init(zone: .monthly, range: 1, start: ShortDateFormatter().string(for: Date.now.previousMonthStart(length: 1))), 
            user: user, 
            db: req.db as! PostgresDatabase
        ).first
        let lastMonthlyRes = try await getTimeLineFreqs(
            data: .init(zone: .monthly, range: 1, start: ShortDateFormatter().string(for: Date.now.previousMonthStart(length: 2))), 
            user: user, 
            db: req.db as! PostgresDatabase
        ).first
        return .init(
            totalCost: totalRes["cost"]!.float!,
            totalCount: totalRes["count"]!.int!,
            currentMonthCost: monthlyRes?.costWeight ?? 0,
            currentMonthCount: monthlyRes?.countWeight ?? 0,
            lastMonthCost: lastMonthlyRes?.costWeight ?? 0,
            lastMonthCount: lastMonthlyRes?.countWeight ?? 0
        )
    }

    @Sendable func timeLineFreqs(req: Request) async throws -> [Overview.TimeLineOUT] {
        let user = try req.auth.require(User.self)
        let data = try req.query.decode(Overview.TimeLineREQ.self)
        return try await getTimeLineFreqs(data: data, user: user, db: req.db as! PostgresDatabase)
    }

    @Sendable func categoryFreqs(req: Request) async throws -> [Overview.CategoryOUT] {
        let user = try req.auth.require(User.self)
        let data = try req.query.decode(Overview.CategoryREQ.self)
        let filters: String
        if let start = data.start {
            guard 
                let startDate = ShortDateFormatter().date(from: start),
                let zone = data.zone,
                let range = data.range
            else {
                throw Abort(.badRequest, reason: "Date formatter is not correct")
            }
            filters = """
                AND transaction_date >= '\(ShortDateFormatter().string(from: startDate))'
                AND transaction_date < '\(ShortDateFormatter().string(from: 
                        zone == .yearly ? startDate.nextYearStart(length: range) : 
                        zone == .monthly ? startDate.nextMonthStart(length: range) : 
                        startDate.nextDayStart(length: range))
                )'
            """
        } else { filters = "" }
        let res = try await (req.db as! PostgresDatabase)
            .query("""
                SELECT category as name, COUNT(*) AS count_weight, SUM(total_price) AS cost_weight
                FROM transactions
                WHERE consumer_id = '\(user.requireID())'
                \(filters)
                GROUP BY name
                ORDER BY name
            """).get()
        return res.rows.map { row in
            let values: [String: PostgresData] = row.datas()
            return Overview.CategoryOUT(name: values["name"]!.string!, costWeight: values["cost_weight"]!.float!, countWeight: values["count_weight"]!.int!)
        }
    }

    @Sendable func itemFreqs(req: Request) async throws -> [Overview.ItemOUT] {
        let user = try req.auth.require(User.self)
        let data = try req.query.decode(Overview.ItemREQ.self)
        let filters: String
        if let start = data.start {
            guard 
                let startDate = ShortDateFormatter().date(from: start),
                let zone = data.zone,
                let range = data.range
            else {
                throw Abort(.badRequest, reason: "Date formatter is not correct")
            }
            filters = """
                AND transaction_date >= '\(ShortDateFormatter().string(from: startDate))'
                AND transaction_date < '\(ShortDateFormatter().string(from: 
                    zone == .yearly ? startDate.nextYearStart(length: range) : 
                    zone == .monthly ? startDate.nextMonthStart(length: range) : 
                    startDate.nextDayStart(length: range))
                )'
            """
        } else { filters = "" }
        let res = try await (req.db as! PostgresDatabase)
            .query("""
                SELECT item_name as item, COUNT(*) AS count_weight, SUM(total_price) AS cost_weight
                FROM transactions
                WHERE consumer_id = '\(user.requireID())'
                \(filters)
                GROUP BY item
                ORDER BY item
            """).get()
        return res.rows.map { row in
            let values: [String: PostgresData] = row.datas()
            return Overview.ItemOUT(item: values["item"]!.string!, costWeight: values["cost_weight"]!.float!, countWeight: values["count_weight"]!.int!)
        }
    }

    @Sendable func getTimeLineFreqs(data: Overview.TimeLineREQ, user: User, db: PostgresDatabase) async throws -> [Overview.TimeLineOUT] {
        let filters: String
        if let start = data.start {
            guard 
                let startDate = ShortDateFormatter().date(from: start),
                let range = data.range
            else {
                throw Abort(.badRequest, reason: "Date formatter is not correct")
            }
            filters = """
                    AND transaction_date >= '\(ShortDateFormatter().string(from: startDate))'
                    AND transaction_date < '\(ShortDateFormatter().string(from: 
                        data.zone == .yearly ? startDate.nextYearStart(length: range) : 
                        data.zone == .monthly ? startDate.nextMonthStart(length: range) : 
                        startDate.nextDayStart(length: range))
                    )'
            """
        } else { filters = "" }
        let sql = try """
            SELECT TO_CHAR(DATE_TRUNC('\(
                data.zone == .yearly ? "year" : 
                data.zone == .monthly ? "month" : 
                "day"
            )', transaction_date), '\(
                data.zone == .yearly ? "YYYY" : 
                data.zone == .monthly ? "YYYY-MM" : 
                "YYYY-MM-DD"
            )') AS date, COUNT(*) AS count_weight, SUM(total_price) AS cost_weight
            FROM transactions
            WHERE consumer_id = '\(user.requireID())'
            \(filters)
            GROUP BY date
            ORDER BY date
        """
        let res = try await db.query(sql).get()
        return res.rows.map { row in
            let values: [String: PostgresData] = row.datas()
            return Overview.TimeLineOUT(date: values["date"]!.string!, costWeight: values["cost_weight"]!.float!, countWeight: values["count_weight"]!.int!)
        }
    }
}