// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension WellBeing: NodeRepresentable {
    internal enum NodeKeys {
        internal static let appUserId = "appUserId"
        internal static let kind = "kind"
        internal static let comment = "comment"
    }

    // MARK: - NodeRepresentable (WellBeing)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(WellBeing.idKey, id)
        try node.set(NodeKeys.appUserId, appUserId)
        try node.set(NodeKeys.kind, kind)
        try node.set(NodeKeys.comment, comment)
        try node.set(WellBeing.createdAtKey, createdAt)
        try node.set(WellBeing.updatedAtKey, updatedAt)

        return node
    }
}
