import FluentProvider

// sourcery: model
internal final class Interests: Model {
    // sourcery: preparation = foreignId, foreignTable = AppUser, ignoreJSONRepresentable
    internal let appUserId: Identifier?
    internal let kind: String

// sourcery:inline:auto:Interests.Models
    internal let storage = Storage()

    internal init(
        appUserId: Identifier? = nil,
        kind: String
    ) {
        self.appUserId = appUserId
        self.kind = kind
    }
// sourcery:end
}

extension Interests {
    internal enum Kind: String {
        case food
        case reading
        case tv
        case arts
        case dancing
        case travel
        case tech
        case economics
        case music
        case sports
    }
}

extension Interests {
    var appUser: Parent<Interests, AppUser> {
        return parent(id: appUserId)
    }
}
