// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OnboardingLibrary",
    platforms: [.iOS(.v26), .watchOS(.v26)],
    products: [
        .library(name: "OnboardingLibrary", targets: ["OnboardingLibrary"])
    ],
	dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
	],
    targets: [
        .target(name: "OnboardingLibrary",
				dependencies: [
                    "MacMagazineLibrary",
                    "MacMagazineUILibrary",
                    .product(name: "Storage", package: "Libraries"),
                    .product(name: "Analytics", package: "Libraries"),
                    .product(name: "UIComponents", package: "Libraries")
                ],
                resources: [.process("Resources")])
    ]
)
