// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Podcast",
	platforms: [.iOS(.v16)],
    products: [
        .library(name: "Podcast", targets: ["Podcast"])
    ],
    targets: [
        .target(name: "Podcast"),
        .testTarget(name: "PodcastTests", dependencies: ["Podcast"])
    ]
)
