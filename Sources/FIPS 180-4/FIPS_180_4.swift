// FIPS 180-4, Secure Hash Standard (NIST, August 2015).
//
// This package types the SHA-2 digest surface once for the Institute and
// witnesses it over pinned swift-crypto. It implements no hash
// arithmetic: the witness seam is the whole of the package (R37;
// CO-05 prohibits a native implementation).
public enum FIPS_180_4 {}
