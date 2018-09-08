import Forms
import Validation

internal struct CreateWellBeingForm {
    internal let kindField: FormField<String>
    internal let commentField: FormField<String>

    internal init(
        kind: String? = nil,
        comment: String? = nil
    ) {

        kindField = FormField(
            value: kind,
            validator: OptionalValidator(
                isOptional: false,
                errorOnNil: WellBeingError.kindIsRequired
            ) {
                guard WellBeing.Kind(rawValue: $0) != nil else {
                    throw WellBeingError.unsupportedKind
                }
            }
        )

        commentField = FormField(
            value: comment,
            validator: OptionalValidator(
                isOptional: kind != WellBeing.Kind.red.rawValue,
                errorOnNil: WellBeingError.commentIsRequried
            ) {
                if kind == WellBeing.Kind.red.rawValue {
                    guard WellBeing.Red(rawValue: $0) != nil else {
                        throw WellBeingError.unsupportedCommentOfRed
                    }
                }

                do {
                    try Count<String>.max(160).validate($0)
                } catch {
                    throw WellBeingError.exceededCommentCharacterLimit
                }
            }
        )
    }
}

// MARK: Validated fields

extension CreateWellBeingForm: Form {
    var fields: [FieldType] {
        return [
            kindField,
            commentField
        ]
    }
}

// MARK: JSON

extension CreateWellBeingForm: JSONInitializable {
    internal init(json: JSON) throws {
        try self.init(
            kind: json.get(WellBeing.JSONKeys.kind),
            comment: json.get(WellBeing.JSONKeys.comment)
        )
    }
}

// MARK: Convenience

extension CreateWellBeingForm {

    var kind: String? {
        return kindField.value
    }

    var comment: String? {
        return commentField.value
    }
}
