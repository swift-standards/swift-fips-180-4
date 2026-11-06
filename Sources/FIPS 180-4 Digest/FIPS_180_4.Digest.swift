internal import Binary
public import Byte

extension FIPS_180_4 {

    public struct Digest: Sendable, Equatable, Hashable {
        public let bytes: [Byte]

        public init(bytes: [Byte]) {
            self.bytes = bytes
        }
    }
}

extension FIPS_180_4.Digest {

    @usableFromInline
    static let lowercaseHexAlphabet: [Byte] = Array("0123456789abcdef".utf8).map(Byte.init(_:))

    public var hex: String {
        Binary.Base.`16`.encode(bytes, alphabet: Self.lowercaseHexAlphabet)
    }

    /// The byte counts FIPS 180-4's hash functions produce: SHA-1, SHA-224, SHA-256, SHA-384 and SHA-512. SHA-512/224
    /// and SHA-512/256 share 28 and 32.
    public static let lengths: Swift::Set<Int> = [20, 28, 32, 48, 64]

    /// The digest lowercase `hex` spells, or `nil` when it isn't lowercase hex of a length FIPS 180-4 produces.
    public init?(hex: String) {
        guard let bytes = Binary.Base.`16`.decode(hex, alphabet: Self.lowercaseHexAlphabet),
            Self.lengths.contains(bytes.count)
        else { return nil }
        self.init(bytes: bytes)
    }
}

extension FIPS_180_4.Digest: Codable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let text = try container.decode(String.self)
        guard let digest = Self(hex: text) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "not a FIPS 180-4 digest: \(text)")
        }
        self = digest
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(hex)
    }
}
