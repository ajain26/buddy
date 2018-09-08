// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "buddyconnect-vapor",
    products: [
        .executable(name: "Run", targets: ["Run"]),
        .library(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.4.4")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/vapor/mysql-provider.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/vapor/redis-provider.git", .upToNextMajor(from: "2.0.1")),
        .package(url: "https://github.com/nodes-vapor/bugsnag.git", .upToNextMajor(from: "1.1.3")),
        .package(url: "https://github.com/nodes-vapor/sugar.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/nodes-vapor/meta.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/nodes-vapor/jwt-keychain.git", .upToNextMajor(from: "0.15.0")),
        .package(url: "https://github.com/nodes-vapor/admin-panel-provider.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/nodes-vapor/admin-panel-nodes-sso.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/nodes-vapor/forms.git", .upToNextMinor(from: "0.6.0")),
        .package(url: "https://github.com/nodes-vapor/storage.git", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/nodes-vapor/push-urban-airship.git", .upToNextMajor(from: "2.0.1"))
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "AdminPanelNodesSSO",
                "AdminPanelProvider",
                "Bugsnag",
                "FluentProvider",
                "Forms",
                "JWTKeychain",
                "Meta",
                "MySQLProvider",
                "RedisProvider",
                "Storage",
                "Sugar",
                "UAPusher",
                "Vapor"
            ]
        ),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        .target(name: "Run", dependencies: ["App"])
    ]
)
