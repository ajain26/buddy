import FluentProvider

// sourcery: model
internal final class WellBeing: Model, Timestampable {
    // sourcery: preparation = foreignId, foreignTable = AppUser, ignoreJSONRepresentable
    internal let appUserId: Identifier?
    internal let kind: String
    internal let comment: String?

// sourcery:inline:auto:WellBeing.Models
    internal let storage = Storage()

    internal init(
        appUserId: Identifier? = nil,
        kind: String,
        comment: String? = nil
    ) {
        self.appUserId = appUserId
        self.kind = kind
        self.comment = comment
    }
// sourcery:end
}

extension WellBeing {
    internal enum Kind: String {
        case green
        case amber
        case red
    }

    internal enum Red: String {
        case senior
        case timeout
    }
}
