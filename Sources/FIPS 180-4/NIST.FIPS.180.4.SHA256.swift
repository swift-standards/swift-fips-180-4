public import Byte

extension NIST.FIPS.`180`.`4` {

    public enum SHA256 {}
}

extension NIST.FIPS.`180`.`4`.SHA256 {

    public static let digestLength = 32

    public static func isDigestHex(_ value: String) -> Bool {
        NIST.FIPS.`180`.`4`.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> NIST.FIPS.`180`.`4`.Digest {
        var hasher = Hasher()
        hasher.update(bytes)
        return hasher.finalize()
    }
}
