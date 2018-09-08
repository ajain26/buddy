// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent

extension Invitation: NodeRepresentable {
    internal enum NodeKeys {
        internal static let invitationCode = "invitationCode"
        internal static let email = "email"
    }

    // MARK: - NodeRepresentable (Invitation)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(Invitation.idKey, id)
        try node.set(NodeKeys.invitationCode, invitationCode)
        try node.set(NodeKeys.email, email)

        return node
    }
}
