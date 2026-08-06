extension FIPS_180_4 {
    /// A finished digest: the exact output bytes of one SHA-2 function.
    /// Byte-for-byte, lowercase-hex-renderable, and comparable — nothing
    /// more; interpretation belongs to consumers.
    public struct Digest: Sendable, Equatable, Hashable {
        public let bytes: [UInt8]

        public init(bytes: [UInt8]) {
            self.bytes = bytes
        }

        /// Lowercase hexadecimal rendering, the interchange form every
        /// Institute receipt uses.
        public var hex: String {
            bytes.map { byte in
                let digits = "0123456789abcdef"
                let high = digits[digits.index(digits.startIndex, offsetBy: Int(byte >> 4))]
                let low = digits[digits.index(digits.startIndex, offsetBy: Int(byte & 0x0f))]
                return String(high) + String(low)
            }.joined()
        }
    }
}
