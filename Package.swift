// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "metal-triangle",
    dependencies: [
        .package(url: "https://github.com/Teeco123/swift-log", from: "0.0.3")
    ],
    targets: [
        .executableTarget(
            name: "metal-triangle",
            dependencies: [
                .product(name: "Logger", package: "swift-log")
            ],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("Foundation")
            ]
        )
    ]
)
