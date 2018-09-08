// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Link: Preparation {
    internal enum DatabaseKeys {
        internal static let id = Link.idKey
        internal static let title = "title"
        internal static let description = "description"
        internal static let url = "url"
    }

    // MARK: - Preparations (Link)
    internal static func prepare(_ database: Database) throws {
        try database.create(self) {
            $0.id()
            $0.string(DatabaseKeys.title)
            $0.string(DatabaseKeys.description)
            $0.string(DatabaseKeys.url)
        }

    }

    internal static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
