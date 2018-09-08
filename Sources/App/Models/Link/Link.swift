import FluentProvider

// sourcery: model
internal final class Link: Model, Timestampable {
    internal var title: String
    internal var description: String
    internal var url: String

// sourcery:inline:auto:Link.Models
    internal let storage = Storage()

    internal init(
        title: String,
        description: String,
        url: String
    ) {
        self.title = title
        self.description = description
        self.url = url
    }
// sourcery:end
}
