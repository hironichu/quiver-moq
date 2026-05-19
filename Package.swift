// swift-tools-version: 6.2

import Foundation
import PackageDescription

let packageDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let localQuiverPackagesRoot = Context.environment["QUIVER_PACKAGES_PATH"]

func quiverPackage(_ repository: String) -> Package.Dependency {
    if let localQuiverPackagesRoot {
        let localURL = URL(fileURLWithPath: localQuiverPackagesRoot, relativeTo: packageDirectory)
            .appendingPathComponent(repository)
            .standardizedFileURL
        let manifestURL = localURL.appendingPathComponent("Package.swift")

        if FileManager.default.fileExists(atPath: manifestURL.path) {
            return .package(path: localURL.path)
        }
    }

    return .package(url: "https://github.com/hironichu/\(repository).git", branch: "experimental/runtime")
}

let package = Package(
    name: "quiver-moq",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "MOQCore", targets: ["MOQCore"]),
        .library(name: "MOQRelay", targets: ["MOQRelay"]),
        .library(name: "MOQClient", targets: ["MOQClient"]),
    ],
    dependencies: [
        quiverPackage("quiver-quic"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.12.0"),
    ],
    targets: [
        .target(
            name: "MOQCore",
            dependencies: [
                .product(name: "QUICCore", package: "quiver-quic"),
                .product(name: "QUICStream", package: "quiver-quic"),
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources/MOQCore"
        ),
        .target(
            name: "MOQRelay",
            dependencies: [
                "MOQCore",
                .product(name: "QUICCore", package: "quiver-quic"),
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources/MOQRelay"
        ),
        .target(
            name: "MOQClient",
            dependencies: [
                "MOQCore",
                .product(name: "QUICCore", package: "quiver-quic"),
                .product(name: "Logging", package: "swift-log"),
            ],
            path: "Sources/MOQClient"
        ),
        .testTarget(
            name: "MOQCoreTests",
            dependencies: [
                "MOQCore",
                "MOQRelay",
                .product(name: "QUICCore", package: "quiver-quic"),
            ],
            path: "Tests/MOQCoreTests"
        ),
    ]
)
