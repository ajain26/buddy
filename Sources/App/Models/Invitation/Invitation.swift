import FluentProvider

/// Invitation used to send code to the user
/// who is supposed to sign up.
// sourcery: model
internal final class Invitation: Model {
    internal var invitationCode: String
    internal var email: String

// sourcery:inline:auto:Invitation.Models
    internal let storage = Storage()

    internal init(
        invitationCode: String,
        email: String
    ) {
        self.invitationCode = invitationCode
        self.email = email
    }
// sourcery:end
}
