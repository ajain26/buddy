import AdminPanelProvider

// sourcery: controller
// sourcery: group = links
internal final class BackendLinkController {
    private let renderer: ViewRenderer

    init(renderer: ViewRenderer) {
        self.renderer = renderer
    }

    // sourcery: route, method = get, path /
    func index(_ req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let links = try Link.makeQuery().all()

        return try renderer.make(
            "AdminPanel/Link/index",
            ["links": links.makeNode(in: nil)],
            for: req
        )
    }

    // sourcery: route, method = get, path = /create
    func create(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let fieldset = try req.fieldset ?? LinkCreateForm().makeFieldset(inValidationMode: .none)

        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset
        ])

        return try renderer.make("AdminPanel/Link/edit", viewData)
    }

    // sourcery: route, method = post, path = /store
    func store(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = try LinkCreateForm(request: req)

        if !form.isValid(inValidationMode: .all) {
            let response = redirect("/admin/backend/links/create")
                .flash(.error, "Validation error")

            response.fieldset = try form.makeFieldset(inValidationMode: .all)
            return response
        }

        guard
            let title = form.title,
            let description = form.description,
            let url = form.url
        else {
            throw Abort(.internalServerError, reason: "Internal validation went wrong.")
        }

        try Link(title: title, description: description, url: url).save()

        return redirect("/admin/backend/links")
            .flash(.success, "Successfully created a Useful Link")
    }

    // sourcery: route, method = get, path = /:linkId/edit
    func edit(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let link: Link
        do {
            link = try req.parameters.next(Link.self)
        } catch {
            return redirect("/admin/backend/links")
                .flash(.error, "Useful Link not found")
        }

        let fieldset = try req.fieldset ?? LinkCreateForm().makeFieldset(inValidationMode: .none)
        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset,
            "link": link
        ])

        return try renderer.make("AdminPanel/Link/edit", viewData)
    }

    // sourcery: route, method = post, path = /:linkId/edit
    func update(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = try LinkCreateForm(request: req)

        let link: Link
        do {
            link = try req.parameters.next(Link.self)
        } catch {
            return redirect("/admin/backend/links")
                .flash(.error, "Useful Link not found")
        }

        if !form.isValid(inValidationMode: .all) {

            guard let linkId = link.id?.int else {
                return redirect("/admin/backend/links")
                    .flash(.error, "Useful Link not found")
            }

            let response = redirect("/admin/backend/links/\(linkId)/edit")
                .flash(.error, "Validation error")

            response.fieldset = try form.makeFieldset(inValidationMode: .nonNil)
            return response
        }

        link.title = form.title ?? link.title
        link.description = form.description ?? link.description
        link.url = form.url ?? link.url

        try link.save()

        return redirect("/admin/backend/links")
            .flash(.success, "Successfully updated Useful Link.")
    }

    // sourcery: route, method = post, path = /:linkId/delete
    func delete(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let link: Link
        do {
            link = try req.parameters.next(Link.self)
        } catch {
            return redirect("/admin/backend/links")
                .flash(.error, "Useful Link not found")
        }

        try link.delete()
        return redirect("/admin/backend/links")
            .flash(.success, "Successfully deleted Useful Link.")
    }
}
