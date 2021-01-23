// swift-tools-version:5.3
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
        .testTarget(name: "SwiftggerTests",
                    dependencies: ["Swiftgger"],
                    resources: [
                        .process("openapi.json")
                    ]
        )
    ]
)
