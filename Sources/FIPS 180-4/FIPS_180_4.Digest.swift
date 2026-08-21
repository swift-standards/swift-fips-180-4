internal import Binary_Base_Primitives
public import Byte_Primitives

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
    static let lowercaseHexAlphabet: [Byte] = Array("0123456789abcdef".utf8).map(Byte.init)

    public var hex: String {
        Binary.Base.`16`.encode(bytes, alphabet: Self.lowercaseHexAlphabet)
    }

    public init?(hex: String) {
        guard let bytes = Binary.Base.`16`.decode(hex, alphabet: Self.lowercaseHexAlphabet)
        else { return nil }
        self.init(bytes: bytes)
    }
}
