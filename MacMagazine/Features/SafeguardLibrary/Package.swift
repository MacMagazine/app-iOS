// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SafeguardLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "SafeguardLibrary", targets: ["SafeguardLibrary"])
    ],
    dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
    ],
    targets: [
        .target(name: "SafeguardLibrary",
                dependencies: [
                    "MacMagazineLibrary",
                    .product(name: "Storage", package: "Libraries"),
                    .product(name: "Utilities", package: "Libraries")
                ]),
        .testTarget(name: "SafeguardLibraryTests",
                    dependencies: ["SafeguardLibrary"])
    ]
)
