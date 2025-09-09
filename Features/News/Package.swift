// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "News",
	platforms: [.iOS(.v17)],
    products: [
        .library(name: "News", targets: ["News"])
    ],
	dependencies: [
		.package(name: "CommonLibrary", path: "../CommonLibrary"),
        .package(name: "Settings", path: "../Settings"),
		.package(url: "https://bitbucket.org/kasros/modules.git", branch: "master")
	],
    targets: [
        .target(name: "News",
				dependencies: ["CommonLibrary", "Settings",
							   .product(name: "CoreLibrary", package: "modules"),
                               .product(name: "YouTubeLibrary", package: "modules"),
							   .product(name: "UIComponentsLibrarySpecial", package: "modules")],
				resources: [.process("Resources")]),
        .testTarget(name: "NewsTests", dependencies: ["News"])
    ]
)
