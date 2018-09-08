import Validation

internal struct Base64ImageValidator: Validator {
    public func validate(_ input: String) throws {
        guard
            input.hasPrefix("data:"),
            // file extension have to be lowercase
            input.contains("jpeg") || input.contains("png") || input.contains("gif")
        else {
            throw error("Image does not have the correct format.")
        }
    }
}
