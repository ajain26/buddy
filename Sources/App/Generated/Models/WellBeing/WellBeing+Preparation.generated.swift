// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension WellBeing: Preparation {
    internal enum DatabaseKeys {
        internal static let id = WellBeing.idKey
        internal static let appUserId = "appUserId"
        internal static let kind = "kind"
        internal static let comment = "comment"
    }

    // MARK: - Preparations (WellBeing)
    internal static func prepare(_ database: Database) throws {
        try database.create(self) {
            $0.id()
            $0.foreignId(for: AppUser.self, optional: true, foreignIdKey: DatabaseKeys.appUserId)
            $0.string(DatabaseKeys.kind)
            $0.string(DatabaseKeys.comment, optional: true)
        }

    }

    internal static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
