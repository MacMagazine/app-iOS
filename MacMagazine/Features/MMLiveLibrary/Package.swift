// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MMLiveLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "MMLiveLibrary", targets: ["MMLiveLibrary"])
    ],
	dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
	],
    targets: [
        .target(name: "MMLiveLibrary",
				dependencies: ["MacMagazineLibrary", "MacMagazineUILibrary",
                    .product(name: "Network", package: "Libraries"),
                    .product(name: "Storage", package: "Libraries"),
                    .product(name: "UIComponents", package: "Libraries")
                ]),
        .testTarget(name: "MMLiveLibraryTests",
                    dependencies: ["MMLiveLibrary"],
                    resources: [.process("Resources")])
    ]
)
