// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VideosLibrary",
	platforms: [.iOS(.v26)],
    products: [
        .library(name: "VideosLibrary", targets: ["VideosLibrary"])
    ],
	dependencies: [
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
		.package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
	],
    targets: [
		.target(name: "VideosLibrary",
				dependencies: ["MacMagazineLibrary", "MacMagazineUILibrary",
                               .product(name: "Storage", package: "Libraries"),
                               .product(name: "Network", package: "Libraries"),
							   .product(name: "YouTube", package: "Libraries"),
							   .product(name: "UIComponents", package: "Libraries")])
    ]
)
