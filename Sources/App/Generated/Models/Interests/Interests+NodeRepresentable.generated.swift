// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Interests: NodeRepresentable {
    internal enum NodeKeys {
        internal static let appUserId = "appUserId"
        internal static let kind = "kind"
    }

    // MARK: - NodeRepresentable (Interests)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(Interests.idKey, id)
        try node.set(NodeKeys.appUserId, appUserId)
        try node.set(NodeKeys.kind, kind)

        return node
    }
}
