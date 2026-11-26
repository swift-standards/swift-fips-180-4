public import Byte

extension NIST.FIPS.`180`.`4`.SHA256 {
    /// A SHA-256 digest of bytes fed a piece at a time, each piece read where it lies: feeding the pieces of a
    /// message gives the digest of the whole message, as `FIPS_180_4.SHA256.digest(_:)` does.
    public struct Hasher: Sendable {
        var h0: UInt32 = 0x6a09_e667
        var h1: UInt32 = 0xbb67_ae85
        var h2: UInt32 = 0x3c6e_f372
        var h3: UInt32 = 0xa54f_f53a
        var h4: UInt32 = 0x510e_527f
        var h5: UInt32 = 0x9b05_688c
        var h6: UInt32 = 0x1f83_d9ab
        var h7: UInt32 = 0x5be0_cd19
        /// The bytes fed since the last whole block, in its first `pending`.
        var buffer = InlineArray<64, UInt8>(repeating: 0)
        var pending = 0
        var totalBytes: UInt64 = 0

        public init() {}
    }
}

extension NIST.FIPS.`180`.`4`.SHA256.Hasher {
    private static let k: InlineArray<64, UInt32> = [
        0x428a_2f98, 0x7137_4491, 0xb5c0_fbcf, 0xe9b5_dba5, 0x3956_c25b, 0x59f1_11f1, 0x923f_82a4, 0xab1c_5ed5,
        0xd807_aa98, 0x1283_5b01, 0x2431_85be, 0x550c_7dc3, 0x72be_5d74, 0x80de_b1fe, 0x9bdc_06a7, 0xc19b_f174,
        0xe49b_69c1, 0xefbe_4786, 0x0fc1_9dc6, 0x240c_a1cc, 0x2de9_2c6f, 0x4a74_84aa, 0x5cb0_a9dc, 0x76f9_88da,
        0x983e_5152, 0xa831_c66d, 0xb003_27c8, 0xbf59_7fc7, 0xc6e0_0bf3, 0xd5a7_9147, 0x06ca_6351, 0x1429_2967,
        0x27b7_0a85, 0x2e1b_2138, 0x4d2c_6dfc, 0x5338_0d13, 0x650a_7354, 0x766a_0abb, 0x81c2_c92e, 0x9272_2c85,
        0xa2bf_e8a1, 0xa81a_664b, 0xc24b_8b70, 0xc76c_51a3, 0xd192_e819, 0xd699_0624, 0xf40e_3585, 0x106a_a070,
        0x19a4_c116, 0x1e37_6c08, 0x2748_774c, 0x34b0_bcb5, 0x391c_0cb3, 0x4ed8_aa4a, 0x5b9c_ca4f, 0x682e_6ff3,
        0x748f_82ee, 0x78a5_636f, 0x84c8_7814, 0x8cc7_0208, 0x90be_fffa, 0xa450_6ceb, 0xbef9_a3f7, 0xc671_78f2,
    ]

    /// Feeds the next bytes of the message.
    public mutating func update(_ bytes: borrowing RawSpan) {
        let count = bytes.byteCount
        totalBytes &+= UInt64(count)
        var offset = 0
        if pending > 0 {
            while pending < 64, offset < count {
                buffer[pending] = unsafe bytes.unsafeLoad(fromByteOffset: offset, as: UInt8.self)
                pending &+= 1
                offset &+= 1
            }
            guard pending == 64 else { return }
            compressBuffer()
        }
        let whole = (count &- offset) / 64
        compress(bytes, from: offset, blocks: whole)
        offset &+= whole &* 64
        while offset < count {
            buffer[pending] = unsafe bytes.unsafeLoad(fromByteOffset: offset, as: UInt8.self)
            pending &+= 1
            offset &+= 1
        }
    }

    /// Feeds the next bytes of the message.
    public mutating func update(_ bytes: [Byte]) {
        unsafe update(bytes.span.bytes)
    }

    private mutating func compressBuffer() {
        let block = buffer
        compress(block.span.bytes, from: 0, blocks: 1)
        pending = 0
    }

    /// Takes in whole blocks, each read where it lies. `bytes` holds at least `blocks` of them past `offset`.
    private mutating func compress(_ bytes: borrowing RawSpan, from offset: Int, blocks: Int) {
        guard blocks > 0 else { return }
        let k = Self.k
        var w = InlineArray<16, UInt32>(repeating: 0)
        var start = offset
        let end = offset &+ blocks &* 64
        while start < end {
            var a = h0
            var b = h1
            var c = h2
            var d = h3
            var e = h4
            var f = h5
            var g = h6
            var h = h7

            var round = 0
            while round < 64 {
                let slot = round & 15
                let word: UInt32
                if round < 16 {
                    word = unsafe bytes.unsafeLoadUnaligned(fromByteOffset: start &+ round &* 4, as: UInt32.self).bigEndian
                } else {
                    let w15 = w[(round &+ 1) & 15]
                    let s0 = ((w15 >> 7) | (w15 << 25)) ^ ((w15 >> 18) | (w15 << 14)) ^ (w15 >> 3)
                    let w2 = w[(round &+ 14) & 15]
                    let s1 = ((w2 >> 17) | (w2 << 15)) ^ ((w2 >> 19) | (w2 << 13)) ^ (w2 >> 10)
                    word = w[slot] &+ s0 &+ w[(round &+ 9) & 15] &+ s1
                }
                w[slot] = word

                let s1 = ((e >> 6) | (e << 26)) ^ ((e >> 11) | (e << 21)) ^ ((e >> 25) | (e << 7))
                let ch = (e & f) ^ ((~e) & g)
                let temp1 = h &+ s1 &+ ch &+ k[round] &+ word
                let s0 = ((a >> 2) | (a << 30)) ^ ((a >> 13) | (a << 19)) ^ ((a >> 22) | (a << 10))
                let maj = (a & b) ^ (a & c) ^ (b & c)
                let temp2 = s0 &+ maj

                h = g
                g = f
                f = e
                e = d &+ temp1
                d = c
                c = b
                b = a
                a = temp1 &+ temp2
                round &+= 1
            }

            h0 &+= a
            h1 &+= b
            h2 &+= c
            h3 &+= d
            h4 &+= e
            h5 &+= f
            h6 &+= g
            h7 &+= h
            start &+= 64
        }
    }

    /// The digest of every byte fed so far. Feeding more afterwards continues the same message.
    public func finalize() -> NIST.FIPS.`180`.`4`.Digest {
        var copy = self
        let bitLength = copy.totalBytes &* 8
        copy.buffer[copy.pending] = 0x80
        copy.pending &+= 1
        if copy.pending > 56 {
            while copy.pending < 64 {
                copy.buffer[copy.pending] = 0
                copy.pending &+= 1
            }
            copy.compressBuffer()
        }
        while copy.pending < 56 {
            copy.buffer[copy.pending] = 0
            copy.pending &+= 1
        }
        var shift = 56
        while shift >= 0 {
            copy.buffer[copy.pending] = UInt8(truncatingIfNeeded: bitLength >> shift)
            copy.pending &+= 1
            shift -= 8
        }
        copy.compressBuffer()
        let words = [copy.h0, copy.h1, copy.h2, copy.h3, copy.h4, copy.h5, copy.h6, copy.h7]
        var result: [Byte] = []
        result.reserveCapacity(32)
        for word in words {
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 24)))
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 16)))
            result.append(Byte(UInt8(truncatingIfNeeded: word >> 8)))
            result.append(Byte(UInt8(truncatingIfNeeded: word)))
        }
        return NIST.FIPS.`180`.`4`.Digest(bytes: result)
    }
}
