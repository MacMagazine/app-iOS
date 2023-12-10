// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "News",
	platforms: [.iOS(.v16)],
    products: [
        .library(name: "News", targets: ["News"])
    ],
    targets: [
        .target(name: "News"),
        .testTarget(name: "NewsTests", dependencies: ["News"])
    ]
)
