// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension WellBeing {
    internal enum JSONKeys {
        internal static let appUserId = "appUserId"
        internal static let kind = "kind"
        internal static let comment = "comment"
    }
}

// MARK: - JSONInitializable (WellBeing)

extension WellBeing: JSONInitializable {
    internal convenience init(json: JSON) throws {
        let appUserId: Identifier? = try json.get(JSONKeys.appUserId)
        let kind: String = try json.get(JSONKeys.kind)
        let comment: String? = try json.get(JSONKeys.comment)

        self.init(
            appUserId: appUserId,
            kind: kind,
            comment: comment
        )
    }
}

// MARK: - JSONRepresentable (WellBeing)

extension WellBeing: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(WellBeing.idKey, id)
        try json.set(JSONKeys.kind, kind)
        try json.set(JSONKeys.comment, comment)

        return json
    }
}

extension WellBeing: JSONConvertible {}

extension WellBeing: ResponseRepresentable {}
