// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeedLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "FeedLibrary", targets: ["FeedLibrary"])
    ],
	dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
	],
    targets: [
        .target(name: "FeedLibrary",
				dependencies: [
                    "MacMagazineLibrary",
                    .product(name: "Network", package: "Libraries"),
                    .product(name: "Storage", package: "Libraries")
                ]),
        .testTarget(name: "FeedLibraryTests",
                    dependencies: ["FeedLibrary"],
                    resources: [.process("Resources")])
    ]
)
