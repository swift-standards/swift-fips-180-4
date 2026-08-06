public import Byte_Primitives
internal import Crypto

extension FIPS_180_4 {
    /// SHA-512 (FIPS 180-4 §6.4), witnessed over swift-crypto.
    public enum SHA512 {}
}

extension FIPS_180_4.SHA512 {
    /// The digest length in bytes (§1, figure 1: 512 bits).
    public static let digestLength = 64

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        let raw = bytes.map(\.underlying)
        var hasher = Crypto.SHA512()
        raw.withUnsafeBytes { buffer in
            hasher.update(bufferPointer: buffer)
        }
        return FIPS_180_4.Digest(bytes: Array(hasher.finalize()).map(Byte.init))
    }
}
