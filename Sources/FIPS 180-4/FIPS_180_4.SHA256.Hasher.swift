public import Byte
internal import Crypto

extension FIPS_180_4.SHA256 {
    /// A SHA-256 digest of bytes fed a piece at a time, each piece read where it lies: feeding the pieces of a
    /// message gives the digest of the whole message, as `FIPS_180_4.SHA256.digest(_:)` does.
    public struct Hasher: Sendable {
        var state = Crypto.SHA256()

        public init() {}
    }
}

extension FIPS_180_4.SHA256.Hasher {
    /// Feeds the next bytes of the message.
    public mutating func update(_ bytes: borrowing RawSpan) {
        bytes.withUnsafeBytes { buffer in
            unsafe state.update(bufferPointer: buffer)
        }
    }

    /// Feeds the next bytes of the message.
    public mutating func update(_ bytes: [Byte]) {
        unsafe update(bytes.span.bytes)
    }

    /// The digest of every byte fed so far. Feeding more afterwards continues the same message.
    public func finalize() -> FIPS_180_4.Digest {
        FIPS_180_4.Digest(bytes: Array(state.finalize()).map(Byte.init(_:)))
    }
}
