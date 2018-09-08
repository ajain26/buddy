import Forms
import HTTP

internal enum TermsAndConditionsError {
    case descriptionIsRequired
}

extension TermsAndConditionsError: AbortError {
    var status: Status {
        return Status.unprocessableEntity
    }

    public var reason: String {
        switch self {
        case .descriptionIsRequired:
            return "Description is required."
        }
    }
}

extension TermsAndConditionsError: FormFieldValidationError {
    var errorReasons: [String] {
        return [reason]
    }
}
