public import Byte

extension FIPS_180_4 {

    public enum SHA384 {}
}

extension FIPS_180_4.SHA384 {

    public static let digestLength = 48

    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        FIPS_180_4.SHA512.hash(
            bytes,
            initial: (
                0xcbbb_9d5d_c105_9ed8, 0x629a_292a_367c_d507, 0x9159_015a_3070_dd17, 0x152f_ecd8_f70e_5939,
                0x6733_2667_ffc0_0b31, 0x8eb4_4a87_6858_1511, 0xdb0c_2e0d_64f9_8fa7, 0x47b5_481d_befa_4fa4
            ),
            outputWords: 6
        )
    }
}
