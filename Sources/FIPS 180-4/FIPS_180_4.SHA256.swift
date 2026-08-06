internal import Crypto

extension FIPS_180_4 {
    /// SHA-256 (FIPS 180-4 §6.2), witnessed over swift-crypto.
    public enum SHA256 {
        /// The digest length in bytes (§1, figure 1: 256 bits).
        public static let digestLength = 32

        public static func digest(_ bytes: [UInt8]) -> Digest {
            var hasher = Crypto.SHA256()
            bytes.withUnsafeBytes { buffer in
                hasher.update(bufferPointer: buffer)
            }
            return Digest(bytes: Array(hasher.finalize()))
        }
    }
}
