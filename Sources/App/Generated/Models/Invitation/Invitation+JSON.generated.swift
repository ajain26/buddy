// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Invitation {
    internal enum JSONKeys {
        internal static let invitationCode = "invitationCode"
        internal static let email = "email"
    }
}

// MARK: - JSONInitializable (Invitation)

extension Invitation: JSONInitializable {
    internal convenience init(json: JSON) throws {
        let invitationCode: String = try json.get(JSONKeys.invitationCode)
        let email: String = try json.get(JSONKeys.email)

        self.init(
            invitationCode: invitationCode,
            email: email
        )
    }
}

// MARK: - JSONRepresentable (Invitation)

extension Invitation: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(Invitation.idKey, id)
        try json.set(JSONKeys.invitationCode, invitationCode)
        try json.set(JSONKeys.email, email)

        return json
    }
}

extension Invitation: JSONConvertible {}

extension Invitation: ResponseRepresentable {}
