import Forms
import HTTP

internal enum LinkError {
    case titleIsRequired
    case descriptionIsRequired
    case urlIsRequired
    case invalidURL
}

extension LinkError: AbortError {
    var status: Status {
        return Status.unprocessableEntity
    }

    public var reason: String {
        switch self {
        case .titleIsRequired:
            return "Title is required."
        case .descriptionIsRequired:
            return "Description is required."
        case .invalidURL:
            return "Wrong URL format."
        case .urlIsRequired:
            return "URL is required."
        }
    }
}

extension LinkError: FormFieldValidationError {
    var errorReasons: [String] {
        return [reason]
    }
}
