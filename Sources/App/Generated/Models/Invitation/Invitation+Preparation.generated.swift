// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Invitation: Preparation {
    internal enum DatabaseKeys {
        internal static let id = Invitation.idKey
        internal static let invitationCode = "invitationCode"
        internal static let email = "email"
    }

    // MARK: - Preparations (Invitation)
    internal static func prepare(_ database: Database) throws {
        try database.create(self) {
            $0.id()
            $0.string(DatabaseKeys.invitationCode)
            $0.string(DatabaseKeys.email)
        }

    }

    internal static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
