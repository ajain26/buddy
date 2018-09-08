import Authentication
import BCrypt
import FluentProvider
import Forms
import HTTP
import JWT
import JWTKeychain
import JWTProvider
import SMTP
import Vapor
import Storage

// sourcery: model
// sourcery: imports = JWTKeychain, imports = Storage
// sourcery: ignoreJSONConvertible
final class AppUser: Model, SoftDeletable, Timestampable {
    internal var email: String
    internal var phone: String
    internal var jobTitle: String
    internal var name: String
    internal let isSenior: Bool
    // sourcery: jsonValue = Storage.getCDNPath(optional: imagePath)
    internal var imagePath: String?
    internal var location: String?
    internal var bio: String?
    // sourcery: ignoreJSONRepresentable
    internal var hashedPassword: String?
    // sourcery: ignoreJSONRepresentable
    internal var passwordVersion: Int = 0

// sourcery:inline:auto:AppUser.Models
    internal let storage = Storage()

    internal init(
        email: String,
        phone: String,
        jobTitle: String,
        name: String,
        isSenior: Bool,
        imagePath: String? = nil,
        location: String? = nil,
        bio: String? = nil,
        hashedPassword: String? = nil,
        passwordVersion: Int
    ) {
        self.email = email
        self.phone = phone
        self.jobTitle = jobTitle
        self.name = name
        self.isSenior = isSenior
        self.imagePath = imagePath
        self.location = location
        self.bio = bio
        self.hashedPassword = hashedPassword
        self.passwordVersion = passwordVersion
    }
// sourcery:end
}

// MARK: Relation

extension AppUser {
    var interests: Children<AppUser, Interests> {
        return children()
    }

    // Need to pass `localIdKey` and `foreignIdKey` because
    // otherwise the Pivot uses the default (here `appUserId`)
    // which isn't existing since it was overriden in `Config+Setup.swift`
    public typealias Buddy = Pivot<AppUser, AppUser>
    var junior: Siblings<AppUser, AppUser, Buddy> {
        return siblings(
            localIdKey: Buddy.leftIdKey,
            foreignIdKey: Buddy.rightIdKey
        )
    }
}

// MARK: - Role with appUser instance

extension AppUser {
    internal enum Role {
        case junior(appUser: AppUser)
        case senior(appUser: AppUser)
    }

    func role() throws -> Role {

        if isSenior {
            guard
                let relation = try AppUser
                    .Buddy
                    .makeQuery()
                    // leftIdKey is `seniorId`
                    .filter(AppUser.Buddy.leftIdKey, id)
                    .first()
            else {
                throw Abort(.internalServerError, reason: "Couldn't find relation to a junior.")
            }

            guard let junior = try AppUser.find(relation.rightId) else {
                throw Abort(.internalServerError, reason: "Couldn't find junior using relation id.")
            }

            return .senior(appUser: junior)
        } else {
            guard
                let relation = try AppUser
                    .Buddy
                    .makeQuery()
                    // rightIdKey is `juniorId`
                    .filter(AppUser.Buddy.rightIdKey, id)
                    .first()
            else {
                throw Abort(.internalServerError, reason: "Couldn't find relation to a senior.")
            }

            guard let senior = try AppUser.find(relation.leftId) else {
                throw Abort(.internalServerError, reason: "Couldn't find senior using relation id.")
            }

            return .junior(appUser: senior)
        }
    }
}

// MARK: EmailAddressRepresentable

extension AppUser: EmailAddressRepresentable {
    var emailAddress: EmailAddress {
        return EmailAddress(address: email)
    }
}

// MARK: PasswordAuthenticatable

extension AppUser: PasswordAuthenticatable {
    public static var passwordVerifier: PasswordVerifier? {
        return bCryptHasher
    }

    public static var bCryptHasher: BCryptHasher {
        return BCryptHasher()
    }
}

// MARK: JWTKeychainAuthenticatable

extension AppUser: JWTKeychainAuthenticatable {

    static func make(request: Request) throws -> AppUser {
        let form = try AppUserCreateForm(request: request)
        try form.validate(inValidationMode: .all)

        guard
            let email = form.email,
            let phone = form.phone,
            let jobTitle = form.jobTitle,
            let name = form.name,
            let role = form.role
        else {
            throw Abort(
                .internalServerError,
                reason: "Could not get values from optional fields despite validation."
            )
        }

        let isSenior = role == AppUserCreateForm.Roles.senior.rawValue

        return AppUser(email: email, phone: phone, jobTitle: jobTitle, name: name, isSenior: isSenior, passwordVersion: 0)
    }
}

// MARK: - RequestUpdateable

extension AppUser: RequestUpdateable {

    func update(request: Request) throws {

        let form: AppUserUpdateForm = try request.createForm()
        try form.fields
            .map { $0 as ValidationModeValidatable }
            .validate(inValidationMode: .nonNil)

        let user: AppUser = try request.auth.assertAuthenticated()

        if let imageData = form.imageData {
            let path = try Storage.upload(dataURI: imageData, folder: "user")
            user.imagePath = path
        }

        user.bio = form.bio ?? user.bio
        user.location = form.location ?? user.location

        if let interests = form.interests {

            let interestsList = try interests.map { (interest: String) throws -> Interests in
                guard let kind = Interests.Kind(rawValue: interest) else {
                    throw AppUserError.invalidInterestsType
                }

                return Interests(appUserId: user.id, kind: kind.rawValue)
            }

            try user.interests.all().forEach { interest in
                try interest.delete()
            }

            for interest in interestsList {
                try interest.save()
            }
        }

    }
}

// MARK: PasswordResettable

extension AppUser: PasswordResettable {
    static func extractPasswordResetInfo(from request: Request) throws -> PasswordResetInfoType {
        return try request.createForm() as PasswordResetForm
    }
}

// MARK: - PasswordUpdateable

extension AppUser: PasswordUpdateable {
    public func updatePassword(to newPassword: String) throws {
        self.hashedPassword = try JWTKeychain.User.bCryptHasher.make(newPassword).makeString()
        self.passwordVersion += 1
    }
}

// MARK: PayloadAuthenticatable

extension AppUser: PayloadAuthenticatable {
    struct AppUserIdentifier: JSONInitializable {
        let id: Identifier

        public init(json: JSON) throws {
            id = Identifier(try json.get(SubjectClaim.name) as Node)
        }
    }

    typealias PayloadType = AppUserIdentifier

    static func authenticate(_ payload: PayloadType) throws -> AppUser {

        guard let user = try find(payload.id) else {
            throw Abort.notFound
        }
        return user
    }
}
