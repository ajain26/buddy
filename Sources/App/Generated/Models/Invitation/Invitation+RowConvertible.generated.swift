// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Invitation: RowConvertible {
    // MARK: - RowConvertible (Invitation)
    convenience internal init (row: Row) throws {
        try self.init(
            invitationCode: row.get(DatabaseKeys.invitationCode),
            email: row.get(DatabaseKeys.email)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.invitationCode, invitationCode)
        try row.set(DatabaseKeys.email, email)

        return row
    }
}
