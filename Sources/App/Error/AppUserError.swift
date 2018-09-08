import Forms
import HTTP

internal enum AppUserError {
    case noSuchInvitationCode
    case missingInvitationCode
    case invalidEmail
    case passwordRequirementNotMet
    case passwordRepeatDoesNotMatch
    case invalidPhone
    case invalidJobTitle
    case invalidName
    case invalidRole
    case invalidLocation
    case invalidBio
    case invalidInterests
    case invalidInterestsType
}

extension AppUserError: AbortError {
    var status: Status {
        return Status.unprocessableEntity
    }

    public var reason: String {
        switch self {
        case .noSuchInvitationCode:
            return "Invitation code does not match with email."
        case .missingInvitationCode:
            return "Invitation code is missing."
        case .invalidEmail:
            return "Invalid email format."
        case .passwordRequirementNotMet:
            return "Password must contain at least 3 of the following: Uppercase character. Lowercase character. Number. Special character."
        case .passwordRepeatDoesNotMatch:
            return "Repeated password does not match former password."
        case .invalidPhone:
            return "Phone cannot be empty."
        case .invalidJobTitle:
            return "Job title cannot be empty."
        case .invalidName:
            return "Name cannot be empty."
        case .invalidRole:
            return "Role cannot be empty."
        case .invalidLocation:
            return "Location cannot be empty"
        case .invalidBio:
            return "Bio cannot be empty"
        case .invalidInterests:
            return "Interests cannot be empty"
        case .invalidInterestsType:
            return "The provided type of interests is not supported."
        }
    }
}

// MARK: Forms

extension AppUserError: FormFieldValidationError {
    var errorReasons: [String] {
        return [reason]
    }
}
