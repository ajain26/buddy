// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Interests: RowConvertible {
    // MARK: - RowConvertible (Interests)
    convenience internal init (row: Row) throws {
        try self.init(
            appUserId: row.get(DatabaseKeys.appUserId),
            kind: row.get(DatabaseKeys.kind)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.appUserId, appUserId)
        try row.set(DatabaseKeys.kind, kind)

        return row
    }
}
