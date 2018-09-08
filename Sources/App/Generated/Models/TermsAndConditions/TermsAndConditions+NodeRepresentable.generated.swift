// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension TermsAndConditions: NodeRepresentable {
    internal enum NodeKeys {
        internal static let description = "description"
    }

    // MARK: - NodeRepresentable (TermsAndConditions)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(TermsAndConditions.idKey, id)
        try node.set(NodeKeys.description, description)
        try node.set(TermsAndConditions.createdAtKey, createdAt)
        try node.set(TermsAndConditions.updatedAtKey, updatedAt)

        return node
    }
}
