// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension AppUser: RowConvertible {
    // MARK: - RowConvertible (AppUser)
    convenience internal init (row: Row) throws {
        try self.init(
            email: row.get(DatabaseKeys.email),
            phone: row.get(DatabaseKeys.phone),
            jobTitle: row.get(DatabaseKeys.jobTitle),
            name: row.get(DatabaseKeys.name),
            isSenior: row.get(DatabaseKeys.isSenior),
            imagePath: row.get(DatabaseKeys.imagePath),
            location: row.get(DatabaseKeys.location),
            bio: row.get(DatabaseKeys.bio),
            hashedPassword: row.get(DatabaseKeys.hashedPassword),
            passwordVersion: row.get(DatabaseKeys.passwordVersion)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.email, email)
        try row.set(DatabaseKeys.phone, phone)
        try row.set(DatabaseKeys.jobTitle, jobTitle)
        try row.set(DatabaseKeys.name, name)
        try row.set(DatabaseKeys.isSenior, isSenior)
        try row.set(DatabaseKeys.imagePath, imagePath)
        try row.set(DatabaseKeys.location, location)
        try row.set(DatabaseKeys.bio, bio)
        try row.set(DatabaseKeys.hashedPassword, hashedPassword)
        try row.set(DatabaseKeys.passwordVersion, passwordVersion)

        return row
    }
}
