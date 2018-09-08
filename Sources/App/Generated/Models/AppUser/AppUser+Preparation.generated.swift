// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent
import JWTKeychain
import Storage

extension AppUser: Preparation {
    internal enum DatabaseKeys {
        internal static let id = AppUser.idKey
        internal static let email = "email"
        internal static let phone = "phone"
        internal static let jobTitle = "jobTitle"
        internal static let name = "name"
        internal static let isSenior = "isSenior"
        internal static let imagePath = "imagePath"
        internal static let location = "location"
        internal static let bio = "bio"
        internal static let hashedPassword = "hashedPassword"
        internal static let passwordVersion = "passwordVersion"
    }

    // MARK: - Preparations (AppUser)
    internal static func prepare(_ database: Database) throws {
        try database.create(self) {
            $0.id()
            $0.string(DatabaseKeys.email)
            $0.string(DatabaseKeys.phone)
            $0.string(DatabaseKeys.jobTitle)
            $0.string(DatabaseKeys.name)
            $0.bool(DatabaseKeys.isSenior)
            $0.string(DatabaseKeys.imagePath, optional: true)
            $0.string(DatabaseKeys.location, optional: true)
            $0.string(DatabaseKeys.bio, optional: true)
            $0.string(DatabaseKeys.hashedPassword, optional: true)
            $0.int(DatabaseKeys.passwordVersion)
        }

    }

    internal static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
