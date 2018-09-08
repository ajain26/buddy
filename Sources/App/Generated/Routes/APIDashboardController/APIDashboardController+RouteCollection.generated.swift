// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension APIDashboardController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("dashboard") { routes in
            // GET /dashboard/
            routes.get("/", handler: dashboard)
        }
    }
}
