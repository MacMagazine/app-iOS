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
        .target(name: "InAppPurchase", dependencies: []),
        .testTarget(name: "InAppPurchaseTests", dependencies: ["InAppPurchase"])
    ]
)
