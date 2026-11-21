public import Byte

extension FIPS_180_4 {

    public enum SHA1 {}
}

extension FIPS_180_4.SHA1 {

    public static let digestLength = 20

    public static func isDigestHex(_ value: String) -> Bool {
        FIPS_180_4.Digest(hex: value)?.bytes.count == digestLength
    }

    public static func digest(_ bytes: [Byte]) -> FIPS_180_4.Digest {
        var h0: UInt32 = 0x6745_2301
        var h1: UInt32 = 0xefcd_ab89
        var h2: UInt32 = 0x98ba_dcfe
        var h3: UInt32 = 0x1032_5476
        var h4: UInt32 = 0xc3d2_e1f0

        let bitLength = UInt64(bytes.count) &* 8
        var padded: [UInt8] = []
        padded.reserveCapacity(((bytes.count + 9 + 63) / 64) * 64)
        for byte in bytes {
            padded.append(byte.bitPattern)
        }
        padded.append(0x80)
        while (padded.count % 64) != 56 {
            padded.append(0)
        }
        var shift = 56
        while shift >= 0 {
            padded.append(UInt8(truncatingIfNeeded: bitLength >> shift))
            shift -= 8
        }

        var w = [UInt32](repeating: 0, count: 80)
        var blockStart = 0
        while blockStart < padded.count {
            var wordIndex = 0
            while wordIndex < 16 {
                let offset = blockStart &+ wordIndex &* 4
                w[wordIndex] =
                    (UInt32(padded[offset]) << 24)
                    | (UInt32(padded[offset &+ 1]) << 16)
                    | (UInt32(padded[offset &+ 2]) << 8)
                    | UInt32(padded[offset &+ 3])
                wordIndex &+= 1
            }
            while wordIndex < 80 {
                let x = w[wordIndex &- 3] ^ w[wordIndex &- 8] ^ w[wordIndex &- 14] ^ w[wordIndex &- 16]
                w[wordIndex] = (x << 1) | (x >> 31)
                wordIndex &+= 1
            }

            var a = h0
            var b = h1
            var c = h2
            var d = h3
            var e = h4

            var round = 0
            while round < 80 {
                let f: UInt32
                let k: UInt32
                if round < 20 {
                    f = (b & c) | ((~b) & d)
                    k = 0x5a82_7999
                } else if round < 40 {
                    f = b ^ c ^ d
                    k = 0x6ed9_eba1
                } else if round < 60 {
                    f = (b & c) | (b & d) | (c & d)
                    k = 0x8f1b_bcdc
                } else {
                    f = b ^ c ^ d
                    k = 0xca62_c1d6
                }
                let temp = ((a << 5) | (a >> 27)) &+ f &+ e &+ k &+ w[round]
                e = d
                d = c
                c = (b << 30) | (b >> 2)
                b = a
                a = temp
                round &+= 1
            }

            h0 &+= a
            h1 &+= b
            h2 &+= c
            h3 &+= d
            h4 &+= e
            blockStart &+= 64
        }

        let words = [h0, h1, h2, h3, h4]
        var result: [Byte] = []
        result.reserveCapacity(20)
        for word in words {
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 24)))
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 16)))
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 8)))
            result.append(Byte(UInt8(truncatingIfNeeded: word)))
        }
        return FIPS_180_4.Digest(bytes: result)
    }
}
