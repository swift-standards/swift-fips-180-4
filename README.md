# swift-fips-180-4

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

FIPS 180-4 (Secure Hash Standard): the Institute's typed SHA-2 digest surface, witnessed over pinned swift-crypto.

## Overview

This package types SHA-256, SHA-384, and SHA-512 digests once for the whole ecosystem under the `FIPS 180-4` target (`FIPS_180_4.SHA256.digest(_:)` and friends, returning a byte-exact `FIPS_180_4.Digest` with lowercase-hex rendering). It implements no hash arithmetic: every digest is computed by pinned [swift-crypto](https://github.com/apple/swift-crypto), and this package is the single sanctioned seam to it (ruling R37, swift-institute/.github#361 — consumers never adopt swift-crypto directly, and no native implementation exists anywhere in the Institute).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-fips-180-4.git", branch: "main")
]
```

## Verification

The test suite pins the standard's own vectors (empty message, "abc", the one- and two-block CAVP messages) for all three functions, with a corrupted-vector negative control, and runs on Linux and macOS.
