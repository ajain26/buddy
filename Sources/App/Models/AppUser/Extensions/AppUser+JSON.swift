import Storage

/// Manually written because `interests` weren't included
/// in the generated one and JWTKeychain responses wouldn't
/// have them included
extension AppUser {
    internal enum JSONKeys {
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
        static let imageData = "imageData"
        static let interests = "interests"
        internal static let buddy = "buddy"
    }
}

// MARK: - JSONRepresentable (AppUser)

extension AppUser: JSONRepresentable {
    internal func makeJSON() throws -> JSON {
        var json = JSON()

        try json.set(AppUser.idKey, id)
        try json.set(JSONKeys.email, email)
        try json.set(JSONKeys.phone, phone)
        try json.set(JSONKeys.jobTitle, jobTitle)
        try json.set(JSONKeys.name, name)
        try json.set(JSONKeys.isSenior, isSenior)
        try json.set(JSONKeys.imagePath, Storage.getCDNPath(optional: imagePath))
        try json.set(JSONKeys.location, location)
        try json.set(JSONKeys.bio, bio)
        try json.set(AppUser.JSONKeys.interests, self.interests.all())

        return json
    }
}

extension AppUser: ResponseRepresentable {}
