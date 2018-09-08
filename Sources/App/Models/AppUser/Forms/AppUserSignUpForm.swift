import Forms
import JWTKeychain
import Validation
import Sugar
import Vapor
import HTTP

internal struct AppUserSignUpForm {
    private let invitationCodeField: FormField<String>
    private let emailField: FormField<String>
    private let passwordField: FormField<String>
    private let passwordRepeatField: FormField<String>

    internal init(
        invitationCode: String? = nil,
        email: String? = nil,
        password: String? = nil,
        passwordRepeat: String? = nil
    ) {
        invitationCodeField = FormField(
            value: invitationCode,
            validator: OptionalValidator(errorOnNil: AppUserError.missingInvitationCode) { invCode in
                guard
                    try Invitation.makeQuery()
                        .filter(Invitation.DatabaseKeys.invitationCode, invCode)
                        .filter(AppUser.DatabaseKeys.email, email)
                        .first() != nil
                    else {
                        throw AppUserError.noSuchInvitationCode
                }
            }
        )

        emailField = FormField(
            value: email,
            validator: EmailValidator()
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidEmail)
        )

        passwordField = FormField(
            value: password,
            validator: StrongPassword()
                .allowingNil(false)
                .transformingErrors(to: AppUserError.passwordRequirementNotMet)
        )

        passwordRepeatField = FormField(
            value: passwordRepeat,
            validator: OptionalValidator(errorOnNil: AppUserError.passwordRepeatDoesNotMatch) {
                if $0 != password {
                    throw JWTKeychainUserError.passwordsDoNotMatch
                }
            }
        )
    }
}

// MARK: - Convenience

extension AppUserSignUpForm {
    var email: String? {
        return emailField.value
    }

    var password: String? {
        return passwordField.value
    }
}

// MARK: - Form

extension AppUserSignUpForm: Form {
    var fields: [FieldType] {
        return [invitationCodeField, emailField, passwordField, passwordRepeatField]
    }
}

// MARK: - JSONInitializable

extension AppUserSignUpForm: JSONInitializable {
    internal init(json: JSON) throws {
        try self.init(
            invitationCode: json.get("invitationCode"),
            email: json.get("email"),
            password: json.get("password"),
            passwordRepeat: json.get("passwordRepeat")
        )
    }
}
