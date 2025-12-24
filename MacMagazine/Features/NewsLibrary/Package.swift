// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NewsLibrary",
	platforms: [.iOS(.v26)],
    products: [
        .library(name: "NewsLibrary", targets: ["NewsLibrary"])
    ],
	dependencies: [
		.package(name: "FeedLibrary", path: "../FeedLibrary"),
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
	],
    targets: [
		.target(name: "NewsLibrary",
				dependencies: ["FeedLibrary", "MacMagazineLibrary", "MacMagazineUILibrary",
                               .product(name: "Storage", package: "Libraries"),
                               .product(name: "Network", package: "Libraries"),
                               .product(name: "Analytics", package: "Libraries"),
							   .product(name: "UIComponents", package: "Libraries")]),
		.testTarget(name: "NewsLibraryTests",
                    dependencies: ["NewsLibrary"],
                    resources: [.process("Resources")])
    ]
)
