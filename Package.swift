// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Jiggler",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Jiggler",
            path: "Sources/Jiggler"
        ),
        .testTarget(
            name: "JigglerTests",
            dependencies: ["Jiggler"],
            path: "Tests/JigglerTests"
        )
    ]
)
