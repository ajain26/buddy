// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension WellBeing: RowConvertible {
    // MARK: - RowConvertible (WellBeing)
    convenience internal init (row: Row) throws {
        try self.init(
            appUserId: row.get(DatabaseKeys.appUserId),
            kind: row.get(DatabaseKeys.kind),
            comment: row.get(DatabaseKeys.comment)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.appUserId, appUserId)
        try row.set(DatabaseKeys.kind, kind)
        try row.set(DatabaseKeys.comment, comment)

        return row
    }
}
