public import Byte
internal import Crypto

extension FIPS_180_4 {

    public enum SHA512 {}
}

extension FIPS_180_4.SHA512 {

    public static let digestLength = 64

    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        let raw = bytes.map(\.underlying)
        var hasher = Crypto.SHA512()
        raw.withUnsafeBytes { buffer in
            hasher.update(bufferPointer: buffer)
        }
        return FIPS_180_4.Digest(bytes: Array(hasher.finalize()).map(Byte.init(_:)))
    }
}
