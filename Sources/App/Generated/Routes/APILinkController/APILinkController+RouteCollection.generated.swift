// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension APILinkController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("links") { routes in
            // GET /links/
            routes.get("/", handler: show)
        }
    }
}
