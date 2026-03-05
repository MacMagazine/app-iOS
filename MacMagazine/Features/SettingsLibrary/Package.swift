// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SettingsLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "SettingsLibrary", targets: ["SettingsLibrary"])
    ],
    dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(name: "MMLiveLibrary", path: "../MMLiveLibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
    ],
    targets: [
        .target(name: "SettingsLibrary",
                dependencies: [
                    "MacMagazineLibrary",
                    "MacMagazineUILibrary",
                    "MMLiveLibrary",
                    .product(name: "InApp", package: "Libraries"),
                    .product(name: "UIComponents", package: "Libraries"),
                    .product(name: "Storage", package: "Libraries"),
                    .product(name: "Analytics", package: "Libraries")
                ],
                resources: [.process("Resources")]),
        .testTarget(name: "SettingsLibraryTests",
                    dependencies: ["SettingsLibrary"])
    ]
)
