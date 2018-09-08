import FluentProvider

// sourcery: model
internal final class TermsAndConditions: Model, Timestampable {
    internal var description: String

// sourcery:inline:auto:TermsAndConditions.Models
    internal let storage = Storage()

    internal init(
        description: String
    ) {
        self.description = description
    }
// sourcery:end
}
