import AdminPanelProvider
import FluentProvider

// sourcery: controller
// sourcery: group = appusers
internal final class BackendAppUserController {
    private let renderer: ViewRenderer
    private let emailService: EmailService

    init(renderer: ViewRenderer, emailService: EmailService) {
        self.renderer = renderer
        self.emailService = emailService
    }

    // sourcery: route, method = get, path = /
    func index (_ req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let appUsers = try AppUser.all()

        return try renderer.make(
            "AdminPanel/AppUser/index",
            ["appUsers": appUsers.makeNode(in: nil)],
            for: req
        )
    }

    // sourcery: route, method = get, path = /create
    func create(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let fieldset = try req.fieldset ?? AppUserCreateForm().makeFieldset(inValidationMode: .none)

        /// fetch all users that are not seniors in the pivot table
        let seniorIds = try Pivot<AppUser, AppUser>.makeQuery().all().map {senior in senior.leftId}
        let users = try AppUser.makeQuery().filter(AppUser.DatabaseKeys.id, notIn: seniorIds).all()

        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset,
            "roles": [
                AppUserCreateForm.Roles.junior.rawValue,
                AppUserCreateForm.Roles.senior.rawValue
            ],
            "users": users.makeNode(in: nil)
        ])

        return try renderer.make("AdminPanel/AppUser/edit", viewData)
    }

    // sourcery: route, method = get, path = /:appUserId/edit
    func edit(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)

        let user: AppUser
        do {
            user = try req.parameters.next(AppUser.self)
        } catch {
            return redirect("/admin/backend/appusers").flash(.error, "User not found")
        }

        let fieldset = try req.fieldset ?? AppUserCreateForm().makeFieldset(inValidationMode: .none)
        let viewData = try ViewData([
            .request: req,
            .fieldset: fieldset,
            "user": user
        ])

        return try renderer.make("AdminPanel/AppUser/edit", viewData)
    }

    // sourcery: route, method = post, path = /:appUserId/edit
    func update(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = AppUserCreateForm(data: req.data)

        let user: AppUser
        do {
            user = try req.parameters.next(AppUser.self)
        } catch {
            return redirect("/admin/backend/appusers").flash(.error, "User not found")
        }

        let newEmail = try AppUser
            .makeQuery()
            .filter(AppUser.DatabaseKeys.email, form.email)
            .first()

        let isEmailUnique = newEmail == nil || newEmail?.id == user.id

        if !form.isValid(inValidationMode: .nonNil) || !isEmailUnique {

            guard let userId = user.id?.int else {
                return redirect("/admin/backend/appusers").flash(.error, "User not found")
            }

            let response = redirect("/admin/backend/appusers/\(userId)/edit")
                .flash(.error, "Validation error")

            var fieldset = try form.makeFieldset(inValidationMode: .nonNil)

            if !isEmailUnique {
                try fieldset.set(
                    "email",
                    try Node(node: [
                        "label": "Email",
                        "value": .string(form.email ?? ""),
                        "errors": Node(node: ["Provided email already exists."])
                    ])
                )
            }

            response.fieldset = fieldset
            return response
        }

        if let email = form.email {
            let code = try generateInvitationCode()
            let invitation = Invitation(invitationCode: code, email: email)
            try invitation.save()

            let context: ViewData = [
                "name": .string(form.name ?? user.name),
                "invitationCode": .string(invitation.invitationCode)
            ]

            try emailService.sendInvitation(to: invitation.email, with: context)
        }

        user.email = form.email ?? user.email
        user.name = form.name ?? user.name
        user.phone = form.phone ?? user.phone
        user.jobTitle = form.jobTitle ?? user.jobTitle

        try user.save()

        return redirect("/admin/backend/appusers")
            .flash(.success, "Successfully updated user.")
    }

    // sourcery: route, method = post, path = /store
    func store(req: Request) throws -> ResponseRepresentable {
        let requestingUser = try req.auth.assertAuthenticated(AdminPanelUser.self)
        try Gate.assertAllowed(requestingUser, requiredRole: .admin)
        let form = try AppUserCreateForm(request: req)

        let isEmailUnique = try AppUser
            .makeQuery()
            .filter(AppUser.DatabaseKeys.email, form.email)
            .first() == nil

        if !form.isValid(inValidationMode: .all) || !isEmailUnique {
            let response = redirect("/admin/backend/appusers/create")
                .flash(.error, "Validation error")

            var fieldset = try form.makeFieldset(inValidationMode: .all)

            if !isEmailUnique {
                try fieldset.set(
                    "email",
                    try Node(node: [
                        "label": "Email",
                        "value": .string(form.email ?? ""),
                        "errors": Node(node: ["Provided email already exists."])
                    ])
                )
            }

            response.fieldset = fieldset
            return response
        }

        if let role = form.role, role == AppUserCreateForm.Roles.junior.rawValue {
            guard let seniorUser = try AppUser.find(form.seniorId) else {
                return redirect("/admin/backend/appusers/create")
                    .flash(.error, "Cannot find senior with id: \(0)")
            }

            let appUser = try AppUser.make(request: req)
            try appUser.save()
            try seniorUser.junior.add(appUser)
        } else {
            let appUser = try AppUser.make(request: req)
            try appUser.save()
        }

        guard let email = form.email, let name = form.name else {
            throw Abort(.internalServerError, reason: "Internal validation went wrong.")
        }

        let code = try generateInvitationCode()
        let invitation = Invitation(invitationCode: code, email: email)
        try invitation.save()

        let context: ViewData = [
            "name": .string(name),
            "invitationCode": .string(invitation.invitationCode)
        ]

        try emailService.sendInvitation(to: invitation.email, with: context)

        return redirect("/admin/backend/appusers/")
            .flash(.success, "Successfully created an AppUser")
    }
}

extension BackendAppUserController {
    private func generateInvitationCode() throws -> String {
        var code = String.randomAlphaNumericString(12)

        while try Invitation
            .makeQuery()
            .filter(Invitation.DatabaseKeys.invitationCode, code)
            .first() != nil
        {
            code = String.randomAlphaNumericString(12)
        }

        return code
    }
}
