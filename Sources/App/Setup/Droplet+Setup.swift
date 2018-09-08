@_exported import Vapor
import AdminPanelProvider
import JWTKeychain
import class Meta.Middleware

extension Droplet {
    public func setup() throws {
        try setupRoutes()

//        database?.log = {
//            print($0)
//        }
    }

    /// Configure all routes
    private func setupRoutes() throws {

        // MARK: Email Service
        let adminPanel = self.config.providers
            .first { $0 is AdminPanelProvider.Provider } as? AdminPanelProvider.Provider

        // use force unwrap to make aware of adminPanel being mandatory
        let panelConfig = adminPanel!.panelConfig

        let emailService = try EmailService(
            renderer: self.view,
            mailer: Mailgun(config: self.config),
            fromEmail: panelConfig.fromEmail ?? "",
            isEmailEnabled: panelConfig.isEmailEnabled
        )

        // MARK: API
        let metaMiddleware = try Meta.Middleware(config: self.config)
        let middlewares = JWTKeychain.Middlewares.secured + [metaMiddleware]

        let api = self.grouped("api")
        try api.collection(APITermsAndConditions())

        let securedApi = api.grouped(middlewares)

        try securedApi.collection(APIAppUserController(push: Push(self.uapusher)))
        try securedApi.collection(APILinkController())
        try securedApi.collection(APIDashboardController())

        // MARK: Backend
        let adminMiddlewares = AdminPanelProvider.Middlewares.secured

        let backend = self.grouped("admin/backend")
        let securedBackend = backend.grouped(adminMiddlewares)

        try securedBackend.collection(
            BackendAppUserController(renderer: self.view, emailService: emailService)
        )

        try securedBackend.collection(BackendTermsAndConditionsController(renderer: self.view))
        try securedBackend.collection(BackendLinkController(renderer: self.view))

        // override dashboard route to go to App User overview instead
        get("admin/dashboard") { _ in
            redirect("/admin/backend/appusers")
        }
    }
}
