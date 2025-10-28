// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Settings", targets: ["Settings"])
    ],
    dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main"),
        .package(url: "https://github.com/OneSignal/OneSignal-XCFramework", from: "5.2.1")
    ],
    targets: [
        .target(name: "Settings",
                dependencies: [
                    "MacMagazineLibrary",
                    .product(name: "OneSignalFramework", package: "OneSignal-XCFramework"),
                    .product(name: "InApp", package: "Libraries"),
                    .product(name: "UIComponents", package: "Libraries"),
                    .product(name: "Storage", package: "Libraries")
                ],
                resources: [.process("Resources")])
    ]
)
