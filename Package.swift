// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-fips-180-4",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "FIPS 180-4", targets: ["FIPS 180-4"]),
        .library(name: "FIPS 180-4 Digest", targets: ["FIPS 180-4 Digest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "5.0.0"),
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-binary.git", branch: "main", traits: ["Base"]),
    ],
    targets: [
        .target(
            name: "FIPS 180-4 Digest",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Binary", package: "swift-binary"),
            ]
        ),
        .target(
            name: "FIPS 180-4",
            dependencies: [
                .target(name: "FIPS 180-4 Digest"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "FIPS 180-4 Tests",
            dependencies: [
                .target(name: "FIPS 180-4"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
