public import Byte

extension FIPS_180_4 {

    public enum SHA256 {}
}

extension FIPS_180_4.SHA256 {

    public static let digestLength = 32

    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        var hasher = Hasher()
        hasher.update(bytes)
        return hasher.finalize()
    }
}
