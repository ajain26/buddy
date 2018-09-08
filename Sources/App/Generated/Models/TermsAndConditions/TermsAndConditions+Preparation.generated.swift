// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension TermsAndConditions: Preparation {
    internal enum DatabaseKeys {
        internal static let id = TermsAndConditions.idKey
        internal static let description = "description"
    }

    // MARK: - Preparations (TermsAndConditions)
    internal static func prepare(_ database: Database) throws {
        try database.create(self) {
            $0.id()
            $0.string(DatabaseKeys.description)
        }

    }

    internal static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
