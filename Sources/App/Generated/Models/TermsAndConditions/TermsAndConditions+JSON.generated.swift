// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension TermsAndConditions {
    internal enum JSONKeys {
        internal static let description = "description"
    }
}

// MARK: - JSONInitializable (TermsAndConditions)

extension TermsAndConditions: JSONInitializable {
    internal convenience init(json: JSON) throws {
        let description: String = try json.get(JSONKeys.description)

        self.init(
            description: description
        )
    }
}

// MARK: - JSONRepresentable (TermsAndConditions)

extension TermsAndConditions: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(TermsAndConditions.idKey, id)
        try json.set(JSONKeys.description, description)

        return json
    }
}

extension TermsAndConditions: JSONConvertible {}

extension TermsAndConditions: ResponseRepresentable {}
