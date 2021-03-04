// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppPurchase",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "InAppPurchase", targets: ["InAppPurchase"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "InAppPurchase",
                dependencies: ["OpenSSL"],
                resources: [.process("Resources")]),
        .binaryTarget(name: "OpenSSL", path: "artifacts/OpenSSL.xcframework")
    ]
)
