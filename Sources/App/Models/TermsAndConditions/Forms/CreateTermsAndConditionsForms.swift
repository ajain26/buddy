import Forms
import Validation

internal struct CreateTermsAndConditionsForm {
    internal let descriptionField: FormField<String>

    internal init(description: String? = nil) {
        self.descriptionField = FormField(
            key: "description",
            label: "Description",
            value: description,
            validator: OptionalValidator(
                isOptional: false,
                errorOnNil: TermsAndConditionsError.descriptionIsRequired
            ) {
                if $0.count < 1 {
                    throw TermsAndConditionsError.descriptionIsRequired
                }
            }
        )
    }
}

// MARK: Validated fields

extension CreateTermsAndConditionsForm: Form {
    var fields: [FieldType] {
        return [descriptionField]
    }
}

// MARK: Request Initializable

extension CreateTermsAndConditionsForm: RequestInitializable {
    init(request: Request) throws {
        let data = request.data
        self.init(description: data[TermsAndConditions.JSONKeys.description]?.string)
    }
}

// MARK: Convenience

extension CreateTermsAndConditionsForm {
    var description: String? {
        return descriptionField.value
    }
}
