// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "coffee-scoop",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        .executableTarget(
            name: "coffee-scoop",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
