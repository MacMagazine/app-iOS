// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacMagazineLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "MacMagazineLibrary", targets: ["MacMagazineLibrary"])
    ],
    dependencies: [
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
    ],
    targets: [
        .target(name: "MacMagazineLibrary",
                dependencies: [
                    .product(name: "UIComponents", package: "Libraries")
                ],
                resources: [.process("Resources")])
    ]
)
