// sourcery: controller
// sourcery: group = dashboard
internal final class APIDashboardController {

    // sourcery: route, method = get, path = /
    func dashboard(req: Request) throws -> ResponseRepresentable {
        let appUser: AppUser = try req.auth.assertAuthenticated()

        var json = JSON()
        try json.set("user", appUser)

        switch try appUser.role() {
        case let AppUser.Role.junior(appUser: senior):
            try json.set(AppUser.JSONKeys.buddy, senior)
        case let AppUser.Role.senior(appUser: junior):
            var juniorJSON = try junior.makeJSON()

            let latestWellbeing = try WellBeing
                .makeQuery()
                .filter(WellBeing.DatabaseKeys.appUserId, junior.id)
                .all()
                .last

            try juniorJSON.set(WellBeing.JSONKeys.latestWellbeing, latestWellbeing?.makeCustomJSON())
            try json.set(AppUser.JSONKeys.buddy, juniorJSON)
        }

        return json
    }
}
