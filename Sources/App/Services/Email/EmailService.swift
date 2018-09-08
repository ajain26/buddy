import AdminPanelProvider
import Vapor
import SMTP

final class EmailService {
    private let renderer: ViewRenderer
    private let mailer: MailProtocol
    private let fromEmail: String
    private let isEmailEnabled: Bool

    init(renderer: ViewRenderer, mailer: MailProtocol, fromEmail: String, isEmailEnabled: Bool) throws {
        self.renderer = renderer
        self.mailer = mailer
        self.fromEmail = fromEmail
        self.isEmailEnabled = isEmailEnabled
    }

    // MARK: App User

    internal func sendInvitation(to: String, with context: ViewData) throws {
        if isEmailEnabled {
            mailer.sendEmail(
                from: fromEmail,
                to: to,
                subject: "Welcome to BuddyConnect",
                path: "AdminPanel/Emails/new-user",
                renderer: renderer,
                context: context
            )
        }
    }
}
