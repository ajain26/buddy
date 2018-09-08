import AdminPanelNodesSSO
import AdminPanelProvider
import Bugsnag
import JWTKeychain
import LeafProvider
import MySQLProvider
import RedisProvider
import Storage
import UAPusher
import class Meta.Middleware

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self, ViewData.self]

        try setupProviders()
        try setupMiddlewares()
        try setupPreparations()
        try setupCommands()
    }

    /// Configure providers
    private func setupProviders() throws {
        try addProvider(MySQLProvider.Provider.self)
        try addProvider(RedisProvider.Provider.self)
        try addProvider(Bugsnag.Provider.self)
        try addProvider(FluentProvider.Provider.self)
        try addProvider(AdminPanelProvider.Provider.self)
        try addProvider(LeafProvider.Provider.self)
        try addProvider(AdminPanelNodesSSO.Provider.self)
        try addProvider(StorageProvider.self)
        try addProvider(UAPusher.Provider.self)

        try addProvider(
            JWTKeychain.Provider<AppUser>(
                apiDelegate: APIAppUserDelegate<AppUser>(),
                settings: Settings(config: self)
            )
        )
    }

    /// Configre middlewares
    private func setupMiddlewares() throws {
        addConfigurable(middleware: Bugsnag.Middleware.init, name: "bugsnag")
        addConfigurable(middleware: Meta.Middleware.init, name: "meta")
    }

    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        preparations.append(AppUser.self)
        preparations.append(Invitation.self)
        preparations.append(Interests.self)
        preparations.append(WellBeing.self)
        preparations.append(TermsAndConditions.self)
        preparations.append(Link.self)

        /// Pivot table describing the relationship between two users
        Pivot<AppUser, AppUser>.leftIdKey = "seniorId"
        Pivot<AppUser, AppUser>.rightIdKey = "juniorId"
        preparations.append(Pivot<AppUser, AppUser>.self)
    }

    /// Configure commands
    private func setupCommands() throws {
        // Add commands here by calling addConfigurable()
    }
}
