import Authentication
import JWTKeychain

internal final class APIAppUserDelegate<U: JWTKeychainUser>: APIUserControllerDelegate<U> {

    /// Register route sets the login password of the user.
    /// The user is by this time already created via cms.
    override func register(
        request: Request,
        tokenGenerators: TokenGenerators
    ) throws -> ResponseRepresentable {
        let form: AppUserSignUpForm = try request.createForm()
        try form.validate(inValidationMode: .all)

        guard
            let email = form.email,
            let password = form.password
        else {
            throw Abort(
                .internalServerError,
                reason: "Could not get values from optional fields despite validation."
            )
        }

        guard
            let user = try AppUser.makeQuery().filter(AppUser.DatabaseKeys.email, email).first()
        else {
            throw Abort(.internalServerError, reason: "Could not find user with email: \(email).")
        }

        user.hashedPassword = try BCryptHasher().make(password).makeString()
        try user.save()
        return try tokenGenerators.makeResponse(for: user, withOptions: .all)
    }

    override func logIn(
        request: Request,
        tokenGenerators: TokenGenerators
    ) throws -> ResponseRepresentable {

        let user = try AppUser.logIn(request: request)
        var respJSON = try tokenGenerators.makeResponse(for: user, withOptions: .all) as! JSON

        if user.isSenior {
            guard let junior = try user.junior.first() else {
                try respJSON.set(AppUser.JSONKeys.buddy, Node.null)
                return respJSON
            }

            var juniorJSON = try junior.makeJSON()

            let latestWellBeing = try WellBeing
                .makeQuery()
                .filter(WellBeing.DatabaseKeys.appUserId, junior.id)
                .all()
                .last

            try juniorJSON.set(WellBeing.JSONKeys.latestWellbeing, latestWellBeing?.makeCustomJSON())
            try respJSON.set(AppUser.JSONKeys.buddy, juniorJSON)
        } else {
            guard
                let relation = try AppUser
                    .Buddy
                    .makeQuery()
                    .filter(AppUser.Buddy.rightIdKey, user.id)
                    .first()
            else {
                throw Abort(.internalServerError, reason: "Could not find a senior.")
            }
            let senior = try AppUser.find(relation.leftId)
            try respJSON.set(AppUser.JSONKeys.buddy, senior)
        }

        return respJSON
    }
}
