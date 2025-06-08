// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "metal-triangle",
  targets: [
    .executableTarget(
      name: "metal-triangle",
      linkerSettings: [
        .linkedFramework("Metal"),
        .linkedFramework("Foundation"),
      ]
    )
  ]
)
