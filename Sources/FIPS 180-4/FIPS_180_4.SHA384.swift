public import Byte_Primitives
internal import Crypto

extension FIPS_180_4 {
    /// SHA-384 (FIPS 180-4 §6.5), witnessed over swift-crypto.
    public enum SHA384 {}
}

extension FIPS_180_4.SHA384 {
    /// The digest length in bytes (§1, figure 1: 384 bits).
    public static let digestLength = 48

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        let raw = bytes.map(\.underlying)
        var hasher = Crypto.SHA384()
        raw.withUnsafeBytes { buffer in
            hasher.update(bufferPointer: buffer)
        }
        return FIPS_180_4.Digest(bytes: Array(hasher.finalize()).map(Byte.init))
    }
}
