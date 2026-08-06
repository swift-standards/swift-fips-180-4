public import Byte_Primitives
internal import Crypto

extension FIPS_180_4 {
    /// SHA-256 (FIPS 180-4 §6.2), witnessed over swift-crypto.
    public enum SHA256 {}
}

extension FIPS_180_4.SHA256 {
    /// The digest length in bytes (§1, figure 1: 256 bits).
    public static let digestLength = 32

    /// True when `value` is the lowercase hex rendering of a SHA-256 digest:
    /// exact lowercase base-16, exactly `digestLength` bytes.
    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        let raw = bytes.map(\.underlying)
        var hasher = Crypto.SHA256()
        raw.withUnsafeBytes { buffer in
            hasher.update(bufferPointer: buffer)
        }
        return FIPS_180_4.Digest(bytes: Array(hasher.finalize()).map(Byte.init))
    }
}
