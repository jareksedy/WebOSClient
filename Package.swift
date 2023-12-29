// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WebOSClient",
    platforms: [.iOS("7.0"), .macOS("10.15"), .watchOS("5.0"), .tvOS("9.0")],
    products: [
        .library(
            name: "WebOSClient",
            targets: ["WebOSClient"]),
    ],
    targets: [
        .target(
            name: "WebOSClient"),
        .testTarget(
            name: "WebOSClientTests",
            dependencies: ["WebOSClient"]),
    ]
)
