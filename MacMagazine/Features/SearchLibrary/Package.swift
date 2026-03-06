// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchLibrary",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "SearchLibrary", targets: ["SearchLibrary"])
    ],
    dependencies: [
        .package(name: "FeedLibrary", path: "../FeedLibrary"),
        .package(name: "MacMagazineLibrary", path: "../MacMagazineLibrary"),
        .package(name: "MacMagazineUILibrary", path: "../MacMagazineUILibrary"),
        .package(name: "PodcastLibrary", path: "../PodcastLibrary"),
        .package(url: "https://github.com/cassio-rossi/Libraries.git", branch: "main")
    ],
    targets: [
        .target(name: "SearchLibrary",
                dependencies: ["FeedLibrary", "MacMagazineLibrary", "MacMagazineUILibrary", "PodcastLibrary",
                               .product(name: "Analytics", package: "Libraries"),
                               .product(name: "Storage", package: "Libraries"),
                               .product(name: "YouTube", package: "Libraries")]),
        .testTarget(name: "SearchLibraryTests",
                    dependencies: ["SearchLibrary"])
    ]
)
