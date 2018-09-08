// sourcery: controller
// sourcery: group = termsandconditions
internal final class APITermsAndConditions {

    // sourcery: route, method = get, path = /
    func show(req: Request) throws -> ResponseRepresentable {

        guard let termsAndConditions = try TermsAndConditions.makeQuery().first() else {
            throw Abort(.unprocessableEntity, reason: "Could not find Terms and Conditions")
        }

        return try termsAndConditions.makeJSON()
    }
}
