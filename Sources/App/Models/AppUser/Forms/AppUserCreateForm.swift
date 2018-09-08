import Forms
import Sugar
import Validation

internal struct AppUserCreateForm {
    internal enum Roles: String {
        case junior
        case senior
    }

    private let emailField: FormField<String>
    private let nameField: FormField<String>
    private let phoneField: FormField<String>
    private let jobTitleField: FormField<String>
    private let roleField: FormField<String>
    private let seniorIdField: FormField<Int>

    let charLimitValidator = Count<String>.min(1) && Count<String>.max(191)

    internal init(
        email: String? = nil,
        name: String? = nil,
        phone: String? = nil,
        jobTitle: String? = nil,
        role: String? = nil,
        seniorId: Int? = nil
    ) {
        emailField = FormField(
            key: "email",
            label: "Email",
            value: email,
            validator: EmailValidator()
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidEmail)
        )

        nameField = FormField(
            key: "name",
            label: "Name",
            value: name,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidPhone)
        )

        phoneField = FormField(
            key: "phone",
            label: "Phone",
            value: phone,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidPhone)
        )

        jobTitleField = FormField(
            key: "jobTitle",
            label: "Job title",
            value: jobTitle,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidJobTitle)
        )

        roleField = FormField(
            key: "role",
            label: "Role",
            value: role,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidRole)
        )

        /// is only optional if `role` is not of type `junior`
        seniorIdField = FormField(
            key: "senior",
            label: "Select a senior",
            value: seniorId,
            validator: OptionalValidator(
                isOptional: role != Roles.junior.rawValue,
                errorOnNil: AppUserError.invalidEmail
            )
        )
    }
}

// MARK: Convenience

extension AppUserCreateForm {
    var email: String? {
        return emailField.value
    }

    var name: String? {
        return nameField.value
    }

    var phone: String? {
        return phoneField.value
    }

    var jobTitle: String? {
        return jobTitleField.value
    }

    var seniorId: Int? {
        return seniorIdField.value
    }

    var role: String? {
        return roleField.value
    }
}

// MARK: Forms

extension AppUserCreateForm: Form {
    var fields: [FieldType] {
        return [emailField, nameField, phoneField, jobTitleField, roleField, seniorIdField]
    }
}

// MARK: JSONInitializable

extension AppUserCreateForm: RequestInitializable {
    init(request: Request) throws {

        let data = request.data

        try self.init(
            email: data.get(AppUser.JSONKeys.email),
            name: data.get(AppUser.JSONKeys.name),
            phone: data.get(AppUser.JSONKeys.phone),
            jobTitle: data.get(AppUser.JSONKeys.jobTitle),
            role: data.get("role"),
            seniorId: Int(data.get("seniorId"))
        )
    }

    init(data: Content) {
        self.init(
            email: data[AppUser.JSONKeys.email]?.string,
            name: data[AppUser.JSONKeys.name]?.string,
            phone: data[AppUser.JSONKeys.phone]?.string,
            jobTitle: data[AppUser.JSONKeys.jobTitle]?.string,
            role: data["role"]?.string,
            seniorId: data["seniorId"]?.int
        )
    }
}
