// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Interests {
    internal enum JSONKeys {
        internal static let appUserId = "appUserId"
        internal static let kind = "kind"
    }
}

// MARK: - JSONInitializable (Interests)

extension Interests: JSONInitializable {
    internal convenience init(json: JSON) throws {
        let appUserId: Identifier? = try json.get(JSONKeys.appUserId)
        let kind: String = try json.get(JSONKeys.kind)

        self.init(
            appUserId: appUserId,
            kind: kind
        )
    }
}

// MARK: - JSONRepresentable (Interests)

extension Interests: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(Interests.idKey, id)
        try json.set(JSONKeys.kind, kind)

        return json
    }
}

extension Interests: JSONConvertible {}

extension Interests: ResponseRepresentable {}
