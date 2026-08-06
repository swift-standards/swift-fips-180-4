// swift-tools-version: 6.3.3

import PackageDescription

// FIPS 180-4 — the Secure Hash Standard's SHA-2 digest surface, typed
// once and witnessed over pinned swift-crypto (ruling R37,
// swift-institute/.github#361). No native hash implementation lives
// here or anywhere in the Institute (CO-05).
let package = Package(
    name: "swift-fips-180-4",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "FIPS 180-4", targets: ["FIPS 180-4"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", exact: "4.5.1"),
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-binary-base-primitives.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "FIPS 180-4",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Binary Base Primitives", package: "swift-binary-base-primitives"),
            ]
        ),
        .testTarget(
            name: "FIPS 180-4 Tests",
            dependencies: [.target(name: "FIPS 180-4")]
        ),
    ],
    swiftLanguageModes: [.v6]
)
