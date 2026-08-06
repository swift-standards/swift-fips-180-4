internal import Crypto

extension FIPS_180_4 {
    /// SHA-512 (FIPS 180-4 §6.4), witnessed over swift-crypto.
    public enum SHA512 {
        /// The digest length in bytes (§1, figure 1: 512 bits).
        public static let digestLength = 64

        public static func digest(_ bytes: [UInt8]) -> Digest {
            var hasher = Crypto.SHA512()
            bytes.withUnsafeBytes { buffer in
                hasher.update(bufferPointer: buffer)
            }
            return Digest(bytes: Array(hasher.finalize()))
        }
    }
}
