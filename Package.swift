// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftgger",
    products: [
        .library(name: "Swiftgger",targets: ["Swiftgger"]),
        .executable(name: "swiftggerapp", targets: ["SwiftggerApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.4.0")
    ],
    targets: [
        .target(name: "Swiftgger", dependencies: ["AnyCodable"]),
        .target(name: "SwiftggerApp", dependencies: ["Swiftgger"]),
        .testTarget(name: "SwiftggerTests",
                    dependencies: ["Swiftgger"],
                    resources: [
                        .process("openapi.json")
                    ]
        )
    ]
)
