// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoLocalized",
    products: [
        .library(name: "AutoLocalizedCore", targets: ["AutoLocalizedCore"]),
        .executable(name: "AutoLocalized", targets: ["AutoLocalized"])
    ],
    dependencies: [
        .package(name: "Yams", url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "AutoLocalized", dependencies: ["AutoLocalizedCore"]),
        .target(name: "AutoLocalizedCore", dependencies: ["Yams"]),
        .testTarget(name: "AutoLocalizedTests", dependencies: ["AutoLocalized"]),
    ]
)
