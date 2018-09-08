// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor

extension BackendTermsAndConditionsController: RouteCollection {
    internal func build(_ builder: RouteBuilder) throws {
        builder.group("termsandconditions") { routes in
            // GET /termsandconditions
            routes.get("", handler: index)
            // GET /termsandconditions/create
            routes.get("/create", handler: create)
            // POST /termsandconditions/store
            routes.post("/store", handler: store)
            // GET /termsandconditions/:termsAndConditionsId/edit
            routes.get("/:termsAndConditionsId/edit", handler: edit)
            // POST /termsandconditions/:termsAndConditionsId/edit
            routes.post("/:termsAndConditionsId/edit", handler: update)
        }
    }
}
