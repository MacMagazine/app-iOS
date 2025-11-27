// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "MMAPI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "MMAPI",
            targets: ["MMAPI"]),
    ],
    targets: [
        .target(
            name: "MMAPI"),
        .testTarget(
            name: "MMAPITests",
            dependencies: ["MMAPI"]
        ),
    ]
)
