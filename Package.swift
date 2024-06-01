// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "coffee-scoop",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "coffee-scoop",
            dependencies: ["SwiftSCAD"]
        ),
    ]
)
