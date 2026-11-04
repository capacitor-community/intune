// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IonicEnterpriseIntune",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "IonicEnterpriseIntune",
            targets: ["IntunePlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor.git", from: "9.0.0-beta.0"),
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git", .upToNextMajor(from: "1.9.0")),
        .package(url: "https://github.com/microsoftconnect/ms-intune-app-sdk-ios.git", .upToNextMajor(from: "21.2.0"))
    ],
    targets: [
        .target(
            name: "IntunePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor"),
                .product(name: "MSAL", package: "microsoft-authentication-library-for-objc"),
                .product(name: "IntuneMAMSwift", package: "ms-intune-app-sdk-ios")
            ],
            path: "ios/Sources/IntunePlugin"
        ),
        .testTarget(
            name: "IntunePluginTests",
            dependencies: ["IntunePlugin"],
            path: "ios/Tests/IntunePluginTests"
        )
    ]
) 