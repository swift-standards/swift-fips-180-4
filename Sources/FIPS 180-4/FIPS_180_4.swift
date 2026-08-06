// FIPS 180-4, Secure Hash Standard (NIST, August 2015).
//
// This package types the standard's digest surface (SHA-1 §6.1,
// SHA-2 §6.2–6.4) once for the Institute and witnesses it over pinned
// swift-crypto. It implements no hash arithmetic: the witness seam is
// the whole of the package (R37; CO-05 prohibits a native
// implementation). SHA-1 is offered for legacy interchange
// coordinates only.
public enum FIPS_180_4 {}
