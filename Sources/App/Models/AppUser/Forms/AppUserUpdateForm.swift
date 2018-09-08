import Forms
import JWTKeychain
import Validation

final class AppUserUpdateForm {
    private let imageDataField: FormField<String>
    private let locationField: FormField<String>
    private let bioField: FormField<String>
    private let interestsField: FormField<[String]>

    let charLimitValidator = Count<String>.min(1) && Count<String>.max(191)

    internal init(
        imageData: String? = nil,
        location: String? = nil,
        bio: String? = nil,
        interests: [String]? = nil
    ) {
        imageDataField = FormField(
            value: imageData,
            validator: Base64ImageValidator().allowingNil(false)
        )

        locationField = FormField(
            value: location,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidLocation)
        )

        bioField = FormField(
            value: bio,
            validator: charLimitValidator
                .allowingNil(false)
                .transformingErrors(to: AppUserError.invalidBio)
        )

        interestsField = FormField(
            value: interests,
            validator: OptionalValidator(errorOnNil: AppUserError.invalidInterests) {
                if $0.count == 0 {
                    throw AppUserError.invalidInterests
                }
            }
        )
    }
}

// MARK: Validated fields

extension AppUserUpdateForm: Form {
    var fields: [FieldType] {
        return [
            imageDataField,
            locationField,
            bioField,
            interestsField
        ]
    }
}

// MARK: JSON

extension AppUserUpdateForm: JSONInitializable {
    internal convenience init(json: JSON) throws {
        try self.init(
            imageData: json.get(AppUser.JSONKeys.imageData),
            location: json.get(AppUser.JSONKeys.location),
            bio: json.get(AppUser.JSONKeys.bio),
            interests: json.get(AppUser.JSONKeys.interests)
        )
    }
}

// MARK: convenience

extension AppUserUpdateForm {
    var imageData: String? {
        return imageDataField.value
    }

    var location: String? {
        return locationField.value
    }

    var bio: String? {
        return bioField.value
    }

    var interests: [String]? {
        return interestsField.value
    }
}
