import Vapor
import Fluent
import FluentPostgresDriver

struct Overview: Content, Sendable {
    enum Zone: String, Codable {
        case yearly = "yearly"
        case monthly = "monthly"
        case daily = "daily"
    }

    struct TimeLineREQ: Content, Sendable {
        let zone: Zone
        let range: Int?
        let start: String?
    }

    struct CategoryREQ: Content, Sendable {
        let zone: Zone?
        let range: Int?
        let start: String?
    }

    struct ItemREQ: Content, Sendable {
        let zone: Zone?
        let range: Int?
        let start: String?
    }
}

extension Overview {

    struct TimeLineOUT: Content, Sendable {
        let date: String
        let costWeight: Float
        let countWeight: Int
    }

    struct CategoryOUT: Content, Sendable {
        let name: String
        let costWeight: Float
        let countWeight: Int
    }

    struct ItemOUT: Content, Sendable {
        let item: String
        let costWeight: Float
        let countWeight: Int
    }

    struct SummaryOUT: Content, Sendable {
        let totalCost: Float
        let totalCount: Int
        let currentMonthCost: Float
        let currentMonthCount: Int
        let lastMonthCost: Float
        let lastMonthCount: Int
    }

}