// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metal-engine",
    dependencies: [],
    targets: [
        .executableTarget(
            name: "metal-engine",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("Foundation")
            ]
        )
    ]
)
