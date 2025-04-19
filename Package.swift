// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSessionTypes",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
        .watchOS(.v6),
        .tvOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftSessionTypes",
            targets: ["SwiftSessionTypes"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftSessionTypes", dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
        .testTarget(
            name: "SwiftSessionTypesTests",
            dependencies: [
                "SwiftSessionTypes",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ]
        ),
        .executableTarget(
            name: "ATM",
            dependencies: ["SwiftSessionTypes"],
            path: "Sources/Examples/ATM"
        ),
        .executableTarget(
            name: "Basic-Example",
            dependencies: ["SwiftSessionTypes"],
            path: "Sources/Examples/Basic-Example"
        ),
    ]
)
