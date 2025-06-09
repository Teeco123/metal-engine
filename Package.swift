// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metal-engine",
    products: [
        .library(
            name: "MetalEngine",
            targets: ["MetalEngine"]
        )
    ],
    targets: [
        .target(
            name: "MetalEngine",
            dependencies: [
                "Utils"
            ],
            path: "Sources/MetalEngine"
        ),
        .target(
            name: "Utils",
            path: "Sources/Utils"
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
