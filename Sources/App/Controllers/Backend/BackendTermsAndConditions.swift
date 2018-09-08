import AdminPanelProvider

// sourcery: controller
// sourcery: group = termsandconditions
internal final class BackendTermsAndConditionsController {
    private let renderer: ViewRenderer

    init(renderer: ViewRenderer) {
        self.renderer = renderer
    }

    // sourcery: route, method = get, path /
    func index(_ req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let termsAndConditions = try TermsAndConditions.makeQuery().first()

        return try renderer.make(
            "AdminPanel/TermsAndConditions/index",
            ["termsandconditions": termsAndConditions.makeNode(in: nil)],
            for: req
        )
    }

    // sourcery: route, method = get, path = /create
    func create(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let fieldset = try req.fieldset ?? CreateTermsAndConditionsForm().makeFieldset(inValidationMode: .none)

        let termsAndConditions = try TermsAndConditions.makeQuery().first()

        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset,
            "termsandconditions": termsAndConditions.makeNode(in: nil)
        ])

        return try renderer.make("AdminPanel/TermsAndConditions/edit", viewData)
    }

    // sourcery: route, method = post, path = /store
    func store(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = try CreateTermsAndConditionsForm(request: req)

        let doesTermsOfConditionsExist = try TermsAndConditions.makeQuery().first() != nil

        if !form.isValid(inValidationMode: .all) || doesTermsOfConditionsExist {
            let response = redirect("/admin/backend/termsandconditions/create")
                .flash(.error, "Validation error")

            var fieldset = try form.makeFieldset(inValidationMode: .all)

            if doesTermsOfConditionsExist {
                try fieldset.set(
                    "description",
                    try Node(node: [
                        "label": "Description",
                        "value": .string(form.description ?? ""),
                        "errors": Node(node: ["You cannot create another Terms of Conditions if one already exists."])
                    ])
                )
            }

            response.fieldset = fieldset
            return response
        }

        guard let description = form.description else {
            throw Abort(.internalServerError, reason: "Internal validation went wrong.")
        }

        try TermsAndConditions(description: description).save()

        return redirect("/admin/backend/termsandconditions")
            .flash(.success, "Successfully created Terms and Conditions")
    }

    // sourcery: route, method = get, path = /:termsAndConditionsId/edit
    func edit(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let termsAndConditions: TermsAndConditions
        do {
            termsAndConditions = try req.parameters.next(TermsAndConditions.self)
        } catch {
            return redirect("/admin/backend/termsandconditions")
                .flash(.error, "Terms and Conditions not found")
        }

        let fieldset = try req.fieldset ?? CreateTermsAndConditionsForm().makeFieldset(inValidationMode: .none)
        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset,
            "termsandconditions": termsAndConditions
            ])

        return try renderer.make("AdminPanel/TermsAndConditions/edit", viewData)
    }

    // sourcery: route, method = post, path = /:termsAndConditionsId/edit
    func update(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = try CreateTermsAndConditionsForm(request: req)

        let termsAndConditions: TermsAndConditions
        do {
            termsAndConditions = try req.parameters.next(TermsAndConditions.self)
        } catch {
            return redirect("/admin/backend/termsandconditions")
                .flash(.error, "Terms and Conditions not found")
        }

        if !form.isValid(inValidationMode: .all) {

            guard let termsAndConditionsId = termsAndConditions.id?.int else {
                return redirect("/admin/backend/termsandconditions")
                    .flash(.error, "Terms and Conditions not found")
            }

            let response = redirect("/admin/backend/termsandconditions/\(termsAndConditionsId)/edit")
                .flash(.error, "Validation error")

            response.fieldset = try form.makeFieldset(inValidationMode: .nonNil)
            return response
        }

        termsAndConditions.description = form.description ?? termsAndConditions.description
        try termsAndConditions.save()

        return redirect("/admin/backend/termsandconditions")
            .flash(.success, "Successfully updated Terms and Conditions.")
    }
}
