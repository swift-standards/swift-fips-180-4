internal import Crypto

extension FIPS_180_4 {
    /// SHA-384 (FIPS 180-4 §6.5), witnessed over swift-crypto.
    public enum SHA384 {
        /// The digest length in bytes (§1, figure 1: 384 bits).
        public static let digestLength = 48

        public static func digest(_ bytes: [UInt8]) -> Digest {
            var hasher = Crypto.SHA384()
            bytes.withUnsafeBytes { buffer in
                hasher.update(bufferPointer: buffer)
            }
            return Digest(bytes: Array(hasher.finalize()))
        }
    }
}
