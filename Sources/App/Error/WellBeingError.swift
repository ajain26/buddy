import Forms
import HTTP

internal enum WellBeingError {
    case appUserIdIsRequired
    case kindIsRequired
    case commentIsRequried
    case unsupportedKind
    case unsupportedCommentOfRed
    case exceededCommentCharacterLimit
}

extension WellBeingError: AbortError {
    var status: Status {
        return Status.unprocessableEntity
    }

    public var reason: String {
        switch self {
        case .appUserIdIsRequired:
            return "appUserId is required."
        case .kindIsRequired:
            return "kind is required."
        case .commentIsRequried:
            return "comment is required."
        case .unsupportedKind:
            return "kind is unsupported. Supported are: green, amber, red."
        case .unsupportedCommentOfRed:
            return "Given comment is unsupported for red. Supported are: senior, timeout."
        case .exceededCommentCharacterLimit:
            return "Comment is too long. Character limit is at 160."
        }
    }
}

extension WellBeingError: FormFieldValidationError {
    var errorReasons: [String] {
        return [reason]
    }
}
