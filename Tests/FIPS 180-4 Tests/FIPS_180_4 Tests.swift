import Byte
import FIPS_180_4
import Testing

@Suite
struct FIPS1804Tests {
    static let abc: [Byte] = Array("abc".utf8).map(Byte.init)
    static let twoBlock: [Byte] = Array(
        "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq".utf8
    ).map(Byte.init)
    static let twoBlock512: [Byte] = Array(
        ("abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn"
            + "hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu").utf8
    ).map(Byte.init)

    @Suite
    struct Unit {
        @Test
        func `sha256 matches the standards vectors`() {
            #expect(
                FIPS_180_4.SHA256.digest([]).hex
                    == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
            )
            #expect(
                FIPS_180_4.SHA256.digest(FIPS1804Tests.abc).hex
                    == "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
            )
            #expect(
                FIPS_180_4.SHA256.digest(FIPS1804Tests.twoBlock).hex
                    == "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
            )
        }

        @Test
        func `sha1 matches the standards vectors`() {
            #expect(
                FIPS_180_4.SHA1.digest([]).hex
                    == "da39a3ee5e6b4b0d3255bfef95601890afd80709"
            )
            #expect(
                FIPS_180_4.SHA1.digest(FIPS1804Tests.abc).hex
                    == "a9993e364706816aba3e25717850c26c9cd0d89d"
            )
            #expect(
                FIPS_180_4.SHA1.digest(FIPS1804Tests.twoBlock).hex
                    == "84983e441c3bd26ebaae4aa1f95129e5e54670f1"
            )
        }

        @Test
        func `sha384 matches the standards vectors`() {
            #expect(
                FIPS_180_4.SHA384.digest([]).hex
                    == "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b"
            )
            #expect(
                FIPS_180_4.SHA384.digest(FIPS1804Tests.abc).hex
                    == "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7"
            )
            #expect(
                FIPS_180_4.SHA384.digest(FIPS1804Tests.twoBlock512).hex
                    == "09330c33f71147e83d192fc782cd1b4753111b173b3b05d22fa08086e3b0f712fcc7c71a557e2db966c3e9fa91746039"
            )
        }

        @Test
        func `sha512 matches the standards vectors`() {
            #expect(
                FIPS_180_4.SHA512.digest([]).hex
                    == "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"
            )
            #expect(
                FIPS_180_4.SHA512.digest(FIPS1804Tests.abc).hex
                    == "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f"
            )
            #expect(
                FIPS_180_4.SHA512.digest(FIPS1804Tests.twoBlock512).hex
                    == "8e959b75dae313da8cf4f72814fc143f8f7779c6eb9f7fa17299aeadb6889018501d289e4900f7e4331b99dec4b5433ac7d329eeb6dd26545e96e55b874be909"
            )
        }
    }

    @Suite
    struct `Edge Case` {
        @Test
        func `hex parse is the exact inverse of hex rendering`() {
            let digest = FIPS_180_4.SHA1.digest(FIPS1804Tests.abc)
            #expect(FIPS_180_4.Digest(hex: digest.hex) == digest)
        }

        @Test
        func `hex parse refuses non-lowercase, odd, and non-hex input`() {
            #expect(FIPS_180_4.Digest(hex: "A9993E364706816ABA3E25717850C26C9CD0D89D") == nil)
            #expect(FIPS_180_4.Digest(hex: "a9993e364706816aba3e25717850c26c9cd0d89") == nil)
            #expect(FIPS_180_4.Digest(hex: "g9993e364706816aba3e25717850c26c9cd0d89d") == nil)
        }

        @Test
        func `isDigestHex accepts exactly the function's own rendering width`() {
            let sha1 = FIPS_180_4.SHA1.digest(FIPS1804Tests.abc).hex
            let sha256 = FIPS_180_4.SHA256.digest(FIPS1804Tests.abc).hex
            #expect(FIPS_180_4.SHA1.isDigestHex(sha1))
            #expect(FIPS_180_4.SHA256.isDigestHex(sha256))
            #expect(!FIPS_180_4.SHA1.isDigestHex(sha256))
            #expect(!FIPS_180_4.SHA256.isDigestHex(sha1))
            #expect(!FIPS_180_4.SHA1.isDigestHex(sha1.uppercased()))
        }

        @Test
        func `digest lengths match the standard`() {
            #expect(FIPS_180_4.SHA1.digest([]).bytes.count == FIPS_180_4.SHA1.digestLength)
            #expect(FIPS_180_4.SHA256.digest([]).bytes.count == FIPS_180_4.SHA256.digestLength)
            #expect(FIPS_180_4.SHA384.digest([]).bytes.count == FIPS_180_4.SHA384.digestLength)
            #expect(FIPS_180_4.SHA512.digest([]).bytes.count == FIPS_180_4.SHA512.digestLength)
        }

        @Test
        func `negative control refuses a corrupted vector`() {

            #expect(
                FIPS_180_4.SHA256.digest(FIPS1804Tests.abc).hex
                    != "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ae"
            )
        }
    }

    @Suite
    struct Integration {
        @Test
        func `digest round trips through hex and equality`() {
            let left = FIPS_180_4.SHA256.digest(FIPS1804Tests.abc)
            let right = FIPS_180_4.SHA256.digest(FIPS1804Tests.abc)
            #expect(left == right)
            #expect(left.hex.count == 2 * FIPS_180_4.SHA256.digestLength)
        }
    }
}
