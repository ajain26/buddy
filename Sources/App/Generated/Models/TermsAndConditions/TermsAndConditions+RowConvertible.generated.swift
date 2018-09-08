// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension TermsAndConditions: RowConvertible {
    // MARK: - RowConvertible (TermsAndConditions)
    convenience internal init (row: Row) throws {
        try self.init(
            description: row.get(DatabaseKeys.description)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.description, description)

        return row
    }
}
