public import Binary_Base_Primitives
public import Byte_Primitives

extension FIPS_180_4 {
    /// A finished digest: the exact output bytes of one SHA-2 function.
    /// Byte-for-byte and comparable — nothing more; interpretation
    /// belongs to consumers.
    public struct Digest: Sendable, Equatable, Hashable {
        public let bytes: [Byte]

        public init(bytes: [Byte]) {
            self.bytes = bytes
        }
    }
}

extension FIPS_180_4.Digest {
    /// The lowercase base-16 alphabet Institute receipts interchange in.
    @usableFromInline
    static let lowercaseHexAlphabet: [Byte] = Array("0123456789abcdef".utf8).map(Byte.init)

    /// Lowercase hexadecimal rendering, composed from the canonical
    /// base-16 encoder (`Binary.Base.16`, swift-binary-base-primitives).
    public var hex: String {
        Binary.Base.`16`.encode(bytes, alphabet: Self.lowercaseHexAlphabet)
    }
}
