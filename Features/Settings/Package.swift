// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Settings", targets: ["Settings"])
    ],
    dependencies: [
        .package(name: "CommonLibrary", path: "../CommonLibrary"),
        .package(url: "https://bitbucket.org/kasros/modules.git", branch: "master"),
        .package(url: "https://github.com/OneSignal/OneSignal-XCFramework", from: "5.2.1")
    ],
    targets: [
        .target(name: "Settings",
                dependencies: ["CommonLibrary",
                               .product(name: "OneSignalFramework", package: "OneSignal-XCFramework"),
                               .product(name: "InAppPurchaseLibrary", package: "modules"),
                               .product(name: "CoreLibrary", package: "modules"),
                               .product(name: "UIComponentsLibrarySpecial", package: "modules")],
                resources: [.process("Resources")]),
        .testTarget(name: "SettingsTests", dependencies: ["Settings"]),
    ]
)
