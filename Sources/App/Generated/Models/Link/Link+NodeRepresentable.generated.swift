// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Link: NodeRepresentable {
    internal enum NodeKeys {
        internal static let title = "title"
        internal static let description = "description"
        internal static let url = "url"
    }

    // MARK: - NodeRepresentable (Link)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(Link.idKey, id)
        try node.set(NodeKeys.title, title)
        try node.set(NodeKeys.description, description)
        try node.set(NodeKeys.url, url)
        try node.set(Link.createdAtKey, createdAt)
        try node.set(Link.updatedAtKey, updatedAt)

        return node
    }
}
