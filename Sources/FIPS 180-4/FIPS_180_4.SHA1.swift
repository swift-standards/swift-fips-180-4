public import Byte_Primitives
internal import Crypto

extension FIPS_180_4 {
    /// SHA-1 (FIPS 180-4 §6.1), witnessed over swift-crypto's
    /// `Insecure.SHA1`. Offered for legacy interchange coordinates
    /// (git object identifiers, GitHub content digests), not for
    /// collision resistance.
    public enum SHA1 {}
}

extension FIPS_180_4.SHA1 {
    /// The digest length in bytes (§1, figure 1: 160 bits).
    public static let digestLength = 20

    /// True when `value` is the lowercase hex rendering of a SHA-1 digest:
    /// exact lowercase base-16, exactly `digestLength` bytes.
    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        let raw = bytes.map(\.underlying)
        var hasher = Crypto.Insecure.SHA1()
        raw.withUnsafeBytes { buffer in
            hasher.update(bufferPointer: buffer)
        }
        return FIPS_180_4.Digest(bytes: Array(hasher.finalize()).map(Byte.init))
    }
}
