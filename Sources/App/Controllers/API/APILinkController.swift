// sourcery: controller
// sourcery: group = links
internal final class APILinkController {

    // sourcery: route, method = get, path = /
    func show(req: Request) throws -> ResponseRepresentable {
        let _: AppUser = try req.auth.assertAuthenticated()

        return try Link.makeQuery().all().makeJSON()
    }
}
