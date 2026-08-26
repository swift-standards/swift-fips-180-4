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
        .library(name: "FIPS 180-4", targets: ["FIPS 180-4"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", exact: "4.5.1"),
        .package(
            url: "https://github.com/swift-molecules/swift-byte.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-base.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "FIPS 180-4",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Binary Base", package: "swift-binary-base"),
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
