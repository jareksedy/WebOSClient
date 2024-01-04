# WebOSClient

[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

WebOSClient is a Swift package that facilitates communication with LG TVs running WebOS. It provides a convenient way to connect to a TV, send commands, and handle various TV-related functionalities.

## Features

- Connect to a WebOS-enabled TV.
- Send commands to control the TV.
- Handle TV events through the delegate pattern.

## Requirements

- Swift 5.0+
- iOS 10.0+ or macOS 10.12+

## Installation

You can integrate WebOSClient into your project using Swift Package Manager. Add the following to your `Package.swift` file:

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/your-username/WebOSClient.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: ["WebOSClient"]
        ),
        // ...
    ]
)
