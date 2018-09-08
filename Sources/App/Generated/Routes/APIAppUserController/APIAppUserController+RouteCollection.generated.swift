// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension APIAppUserController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("users") { routes in
            // GET /users/:appUserId
            routes.get("/:appUserId", handler: show)
            // POST /users/wellbeings
            routes.post("/wellbeings", handler: storeWellbeing)
            // GET /users/wellbeings
            routes.get("/wellbeings", handler: listWellbeings)
            // GET /users/:appUserId/wellbeings
            routes.get("/:appUserId/wellbeings", handler: showWellbeing)
        }
    }
}
