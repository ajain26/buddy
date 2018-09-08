// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Link {
    internal enum JSONKeys {
        internal static let title = "title"
        internal static let description = "description"
        internal static let url = "url"
    }
}

// MARK: - JSONInitializable (Link)

extension Link: JSONInitializable {
    internal convenience init(json: JSON) throws {
        let title: String = try json.get(JSONKeys.title)
        let description: String = try json.get(JSONKeys.description)
        let url: String = try json.get(JSONKeys.url)

        self.init(
            title: title,
            description: description,
            url: url
        )
    }
}

// MARK: - JSONRepresentable (Link)

extension Link: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(Link.idKey, id)
        try json.set(JSONKeys.title, title)
        try json.set(JSONKeys.description, description)
        try json.set(JSONKeys.url, url)

        return json
    }
}

extension Link: JSONConvertible {}

extension Link: ResponseRepresentable {}
