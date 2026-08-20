// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Jigla",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "Jigla",
            path: "Sources/Jigla"
        ),
        .testTarget(
            name: "JiglaTests",
            dependencies: ["Jigla"],
            path: "Tests/JiglaTests"
        )
    ]
)
