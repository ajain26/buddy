// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Link: RowConvertible {
    // MARK: - RowConvertible (Link)
    convenience internal init (row: Row) throws {
        try self.init(
            title: row.get(DatabaseKeys.title),
            description: row.get(DatabaseKeys.description),
            url: row.get(DatabaseKeys.url)
        )
    }

    internal func makeRow() throws -> Row {
        var row = Row()

        try row.set(DatabaseKeys.title, title)
        try row.set(DatabaseKeys.description, description)
        try row.set(DatabaseKeys.url, url)

        return row
    }
}
