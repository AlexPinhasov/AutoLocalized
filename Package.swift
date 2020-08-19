// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoLocalized",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v13)
    ],
    products: [
        .executable(name: "AutoLocalized", targets: ["AutoLocalized"]),
        .library(name: "AutoLocalized", targets: ["AutoLocalized"])
    ],
    targets: [
        .target(name: "AutoLocalized", dependencies: []),
        .testTarget(name: "AutoLocalizedTests", dependencies: ["AutoLocalized"]),
    ]
)
