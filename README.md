# swift-fips-180-4

Use this package when you need a SHA-1, SHA-256, SHA-384 or SHA-512 digest of bytes, or need to check that a string is such a digest in hex. Start from `FIPS_180_4.SHA256`, or `FIPS_180_4.SHA1`, `FIPS_180_4.SHA384` or `FIPS_180_4.SHA512`, and work with the `FIPS_180_4.Digest` they return. SHA-224, SHA-512/224 and SHA-512/256 are not provided.

## Laws

- `FIPS_180_4.Digest.hex` is lowercase, two characters per byte.
- `FIPS_180_4.Digest.init(hex:)` accepts only lowercase hex of even length and returns nil for anything else, including uppercase. It is the exact inverse of `FIPS_180_4.Digest.hex`.
- A `FIPS_180_4.Digest` doesn't record which function made it or check its length, so `FIPS_180_4.Digest.init(hex:)` accepts any even-length lowercase hex. To check that a string is a digest of one function, use that function's check, such as `FIPS_180_4.SHA256.isDigestHex(_:)`, which also requires its exact width.
