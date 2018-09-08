import Forms
import Validation
import Sugar

internal struct LinkCreateForm {
    internal let titleField: FormField<String>
    internal let descriptionField: FormField<String>
    internal let urlField: FormField<String>

    internal init(title: String? = nil, description: String? = nil, url: String? = nil) {
        self.titleField = FormField(
            key: "title",
            label: "Title",
            value: title,
            validator: OptionalValidator(
                isOptional: false,
                errorOnNil: LinkError.titleIsRequired
            ) {
                if $0.count < 1 {
                    throw LinkError.titleIsRequired
                }
            }
        )

        self.descriptionField = FormField(
            key: "description",
            label: "Description",
            value: description,
            validator: OptionalValidator(
                isOptional: false,
                errorOnNil: LinkError.descriptionIsRequired
            ) {
                if $0.count < 1 {
                    throw LinkError.descriptionIsRequired
                }
            }
        )

        self.urlField = FormField(
            key: "url",
            label: "URL",
            value: url,
            validator: OptionalValidator(
                isOptional: false,
                errorOnNil: LinkError.urlIsRequired
            ) {
                try URL().validate($0)
            }.transformingErrors(to: LinkError.invalidURL)
        )
    }
}

// MARK: Validated fields

extension LinkCreateForm: Form {
    var fields: [FieldType] {
        return [titleField, descriptionField, urlField]
    }
}

// MARK: Request Initializable

extension LinkCreateForm: RequestInitializable {
    init(request: Request) throws {
        let data = request.data
        self.init(
            title: data[Link.JSONKeys.title]?.string,
            description: data[Link.JSONKeys.description]?.string,
            url: data[Link.JSONKeys.url]?.string
        )
    }
}

// MARK: Convenience

extension LinkCreateForm {
    var title: String? {
        return titleField.value
    }

    var description: String? {
        return descriptionField.value
    }

    var url: String? {
        return urlField.value
    }
}
