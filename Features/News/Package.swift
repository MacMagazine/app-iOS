// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "News",
	platforms: [.iOS(.v16)],
    products: [
        .library(name: "News", targets: ["News"])
    ],
	dependencies: [
		.package(name: "CommonLibrary", path: "../CommonLibrary"),
		.package(url: "https://bitbucket.org/kasros/modules.git", branch: "master")
	],
    targets: [
        .target(name: "News",
				dependencies: ["CommonLibrary",
							   .product(name: "CoreLibrary", package: "modules"),
							   .product(name: "UIComponentsLibrary", package: "modules")],
				resources: [.process("Resources")]),
        .testTarget(name: "NewsTests", dependencies: ["News"])
    ]
)
