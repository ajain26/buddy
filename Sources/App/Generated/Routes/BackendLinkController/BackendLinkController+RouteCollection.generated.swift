// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension BackendLinkController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("links") { routes in
            // GET /links
            routes.get("", handler: index)
            // GET /links/create
            routes.get("/create", handler: create)
            // POST /links/store
            routes.post("/store", handler: store)
            // GET /links/:linkId/edit
            routes.get("/:linkId/edit", handler: edit)
            // POST /links/:linkId/edit
            routes.post("/:linkId/edit", handler: update)
            // POST /links/:linkId/delete
            routes.post("/:linkId/delete", handler: delete)
        }
    }
}
