// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension APITermsAndConditions: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("termsandconditions") { routes in
            // GET /termsandconditions/
            routes.get("/", handler: show)
        }
    }
}
