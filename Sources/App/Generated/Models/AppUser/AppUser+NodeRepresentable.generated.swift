// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Vapor
import Fluent
import JWTKeychain
import Storage

extension AppUser: NodeRepresentable {
    internal enum NodeKeys {
        internal static let email = "email"
        internal static let phone = "phone"
        internal static let jobTitle = "jobTitle"
        internal static let name = "name"
        internal static let isSenior = "isSenior"
        internal static let imagePath = "imagePath"
        internal static let location = "location"
        internal static let bio = "bio"
        internal static let hashedPassword = "hashedPassword"
        internal static let passwordVersion = "passwordVersion"
    }

    // MARK: - NodeRepresentable (AppUser)
    internal func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        try node.set(AppUser.idKey, id)
        try node.set(NodeKeys.email, email)
        try node.set(NodeKeys.phone, phone)
        try node.set(NodeKeys.jobTitle, jobTitle)
        try node.set(NodeKeys.name, name)
        try node.set(NodeKeys.isSenior, isSenior)
        try node.set(NodeKeys.imagePath, imagePath)
        try node.set(NodeKeys.location, location)
        try node.set(NodeKeys.bio, bio)
        try node.set(NodeKeys.hashedPassword, hashedPassword)
        try node.set(NodeKeys.passwordVersion, passwordVersion)
        try node.set(AppUser.createdAtKey, createdAt)
        try node.set(AppUser.updatedAtKey, updatedAt)

        return node
    }
}
