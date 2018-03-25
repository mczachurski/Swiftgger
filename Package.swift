// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftgger",
    products: [
        .library(name: "Swiftgger",targets: ["Swiftgger"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Swiftgger", dependencies: []),
        .testTarget(name: "SwiftggerTests", dependencies: ["Swiftgger"]),
    ]
)
