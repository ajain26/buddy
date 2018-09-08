import FluentProvider
import Foundation
import Sugar

// sourcery: controller
// sourcery: group = users
internal final class APIAppUserController {
    let push: Push

    internal init(push: Push) {
        self.push = push
    }

    // sourcery: route, method = get, path = /:appUserId
    func show(req: Request) throws -> ResponseRepresentable {
        let appUser: AppUser = try req.auth.assertAuthenticated()

        switch try appUser.role() {
        case let AppUser.Role.junior(appUser: senior):
            let requestedUser: AppUser = try req.parameters.next()
            guard requestedUser.id == senior.id else {
                throw Abort(
                    .unauthorized,
                    reason: "Juniors are only allowed to view the profile of their senior buddy."
                )
            }

            return requestedUser
        case let AppUser.Role.senior(appUser: junior):
            let requestedUser: AppUser = try req.parameters.next()
            guard requestedUser.id == junior.id else {
                throw Abort(
                    .unauthorized,
                    reason: "Seniors are only allowed to view the profile of their junior buddy."
                )
            }

            return requestedUser
        }
    }

    // sourcery: route, method = post, path = /wellbeings
    func storeWellbeing(req: Request) throws -> ResponseRepresentable {
        let appUser: AppUser = try req.auth.assertAuthenticated()
        let form: CreateWellBeingForm = try req.createForm()
        try form.validate(inValidationMode: .all)

        guard let kind = form.kind else {
            throw Abort(.internalServerError, reason: "Internal validation went wrong.")
        }

        let wellbeing = WellBeing(appUserId: appUser.id, kind: kind, comment: form.comment)
        try wellbeing.save()

        if case let AppUser.Role.junior(senior) = try appUser.role() {
            guard let seniorId = senior.id?.int else {
                throw Abort(.internalServerError, reason: "Couldn't convert user id into int.")
            }

            try push.send(message: wellbeing.kind, to: seniorId)
        }

        return wellbeing
    }

    // sourcery: route, method = get, path = /wellbeings
    func listWellbeings(req: Request) throws -> ResponseRepresentable {
        let appUser: AppUser = try req.auth.assertAuthenticated()

        let wellbeings = try WellBeing.makeQuery().filter(WellBeing.DatabaseKeys.appUserId, appUser.id)

        return try wellbeings.paginatorWithLastId(req: req) { wellbeings in
            return try wellbeings.makeJSONGroupedByDate()
        }
    }

    // sourcery: route, method = get, path = /:appUserId/wellbeings
    func showWellbeing(req: Request) throws -> ResponseRepresentable {
        let appUser: AppUser = try req.auth.assertAuthenticated()

        guard appUser.isSenior else {
            throw Abort(
                .unprocessableEntity,
                reason: "Only seniors can request wellbeings of other users."
            )
        }

        let user: AppUser = try req.parameters.next()

        let wellbeings = try WellBeing.makeQuery().filter(WellBeing.DatabaseKeys.appUserId, user.id)
        return try wellbeings.paginatorWithLastId(req: req) { wellbeings in
            return try wellbeings.makeJSONGroupedByDate()
        }
    }
}

internal extension Query where E: JSONRepresentable & Timestampable {
    internal func paginatorWithLastId(
        req: Request,
        transform: (([E]) throws -> [JSON])? = nil
    ) throws -> ResponseRepresentable {
        var startDate: Date? = Calendar.current.date(byAdding: .day, value: -7, to: Date())

        // the older date in comparison to endDate (the newer date)
        if let date = req.query?["startDate"]?.string {
            startDate = Date.parse(.date, date)
        }

        var query = try self
            .filter(E.createdAtKey, .greaterThanOrEquals, startDate)
            .sort(E.idKey, .descending)

        // the newer date in comparison to startDate (the older date)
        if let endDate = req.query?["endDate"]?.string {

            let date = Date.parse(.date, endDate)?.addDay()
            query = try query.filter(E.createdAtKey, .lessThanOrEquals, date)
        }

        let models = try query.all()

        var paginator = JSON()
        try paginator.set("startDate", startDate?.toDateString())

        var json = JSON()
        try json.set("paginator", paginator)
        try json.set("list", transform?(models) ?? models)

        return json
    }
}

internal extension Sequence where Element: Timestampable & JSONRepresentable {

    internal func makeJSONGroupedByDate() throws -> [JSON] {
        var dictionary: [String: [JSON]] = [:]

        try self.forEach { el in

            guard let date = el.createdAt else {
                return
            }

            let dateString = try date.toDateString()

            var json = try el.makeJSON()
            try json.set(Element.createdAtKey, el.createdAt)

            if dictionary[dateString] == nil {
                dictionary[dateString] = [json]
            } else {
                dictionary[dateString]?.append(json)
            }
        }


        // define date boundaries
        var earliestDate: Date? = nil
        var latestDate: Date? = nil
        self.forEach { el in

            guard let date = el.createdAt else {
                return
            }

            // in the first iteration assign dates to global variables
            if earliestDate == nil {
                earliestDate = date
            }

            if latestDate == nil {
                latestDate = date
            }

            // override global variables if necessary
            if let eDate = earliestDate {
                earliestDate = eDate > date ? date : eDate
            }

            if let lDate = latestDate {
                latestDate = lDate < date ? date : lDate
            }
        }

        guard
            var eDate = earliestDate?.startOfDay(),
            let lDate = latestDate?.endOfDay()
        else {
            return []
        }

        // fill dictionary with missing dates between defined boundaries
        var groupWithDateGaps: [String: [JSON]] = [:]
        while eDate <= lDate {

            let eDateString = try eDate.toDateString()

            if dictionary[eDateString] == nil {
                groupWithDateGaps[eDateString] = []
            } else {
                groupWithDateGaps[eDateString] = dictionary[eDateString]
            }

            guard
                let newDate = Calendar.current.date(byAdding: .day, value: 1, to: eDate)
            else {
                throw Abort(
                    .internalServerError,
                    reason: "Could not calculate next date when attempting to create list of wellbeings."
                )
            }

            eDate = newDate
        }

        let sortedValues = groupWithDateGaps.sorted { (a, b) in
            return a.0 > b.0
        }

        return try sortedValues.map { (key, value) in
            var json = JSON()
            try json.set("date", key)
            try json.set("values", value)
            return json
        }
    }
}
