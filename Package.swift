// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metal-engine",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "MetalEngine",
            targets: ["MetalEngine"]
        )
    ],
    targets: [
        .target(
            name: "MetalEngine",
            path: "Sources/MetalEngine"
        ),
        .executableTarget(
            name: "BareDemo",
            dependencies: ["MetalEngine"],
            path: "Examples/BareDemo",
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        )
    ]
)
