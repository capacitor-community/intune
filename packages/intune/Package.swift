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
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/AzureAD/microsoft-authentication-library-for-objc.git", .upToNextMajor(from: "1.9.0")),
        .package(url: "https://github.com/microsoftconnect/ms-intune-app-sdk-ios.git", .upToNextMajor(from: "21.2.0"))
    ],
    targets: [
        .target(
            name: "IntunePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
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