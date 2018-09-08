// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension BackendAppUserController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("appusers") { routes in
            // GET /appusers/
            routes.get("/", handler: index )
            // GET /appusers/create
            routes.get("/create", handler: create)
            // GET /appusers/:appUserId/edit
            routes.get("/:appUserId/edit", handler: edit)
            // POST /appusers/:appUserId/edit
            routes.post("/:appUserId/edit", handler: update)
            // POST /appusers/store
            routes.post("/store", handler: store)
        }
    }
}
