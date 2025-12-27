// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacMagazineLibrary",
    platforms: [.iOS(.v26), .watchOS(.v26)],
    products: [
        .library(name: "MacMagazineLibrary", targets: ["MacMagazineLibrary"])
    ],
    dependencies: [
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main"),
        .package(url: "https://github.com/OneSignal/OneSignal-XCFramework", from: "5.2.1")
    ],
    targets: [
        .target(name: "MacMagazineLibrary",
                dependencies: [
                    .product(name: "Analytics", package: "Libraries"),
                    .product(name: "Logger", package: "Libraries"),
                    .product(name: "Utilities", package: "Libraries"),
                    .product(name: "UIComponents", package: "Libraries"),
                    .product(name: "OneSignalFramework",
                             package: "OneSignal-XCFramework",
                             condition: .when(platforms: [.iOS, .macOS, .visionOS]))
                ],
                resources: [.process("Resources")]),
        .testTarget(name: "MacMagazineLibraryTests",
                    dependencies: ["MacMagazineLibrary"])
    ]
)
