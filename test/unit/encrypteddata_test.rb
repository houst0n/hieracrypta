require 'hieracrypta'
require 'test/unit'

class EncryptedDataTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    @hc_privkey = "-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

lQHYBFMMw1wBBAC2fLrb701GSKAUJ7IJhRcTF2tGxLqGNrl+YBXluY2jmjLAdVpo
7IYyWQsYlAv5kLmWrdhzR8snXigib2484AawQYUD+JrPOhAHNnCNWNkBoB4Pskl2
dnANB1oGFOUJQahjJ2SZFaK5+dluL4CnmJf2ffo39H+UW9GxHSvzrrsFYQARAQAB
AAP/TGNq7sy9yql1BOrW7oA9N/sqJ04LjEoVHM8I64hgP3c5PnIBXgGAbUvzxp6W
YqoP3gC4pg0L/9c8sql1elsGwQRjZ1VHek2aTaE7kIZiDO23WoRfgb9PcYVkGL1f
D0pGX+3Ke+kYsJtf+ls2BvpQhAb/50sPyONLNQxxArjv3qcCAMQMlMuaFgbSK6HO
9lNwlGTSrBX0HBHippVtxTCQItoIOdDAc/pFlwINOBu91r0K/GOB2fTSGIHW/rEn
JYgG80cCAO5KeUtVHQ62PRUCeTPKS1AveKWTgWabsqYb6xoEvocKA2KSkR/uQ+mr
NSpkL7mHDFUoWaQkiZw7F25bFZEchhcCAKViL3G51m1URiVQITBXCmOeRMEbvYDW
2ZmgAuUNunSXEsoQPpYL46XmQZpEIABMj7UNJxUJCLKiEWmZw44VzKWQTrQrSGll
cmFDcnlwdGEgVGVzdCBLZXkgPGhpZXJhY3J5cHRhQGRldi5udWxsPoi3BBMBCgAh
BQJTDMNcAhsDBQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAAAoJEPHJCcLcUMjQPLQD
/0LYIybybuzYP163bXw3pwkDoZgTNP4ZEg6mLVuHcgLYap8WH2TGKGQVIL5TkmoN
beUc3Gis3FX7odIN1z8yJyZmXAOsvsK08Xh7LWQsjI7wisKbueg7eQRU5bPN9JtS
IsFpj91yoJG8cCRPpkc6fCFEFp/1/ZjhxX+sbXUyXiX9nQHYBFMMw1wBBAD0M5SB
7JXVBf911LgMvAnbQzx/GSsgDhAmX6x6Y/a2JlKz74HLonM4vRbzEEN082kj7eve
kgzobUb6jVMbCqPgP/nmXMz+5nzIohR/1epmLvmmkhvR1hNY6n6t43p4pNp6UXLE
MVVxroUJP+e3Lp6AnGNfQBbfBRr5KX/1gsWqXQARAQABAAP+OUxR++M4a82WuX3S
OpCzalpeGz9bTk/ma66WsHf8lxQqYxRfOtnQ2b8KX7lQ7qO/Z4IHjkdsFmwvk5Ht
7kIinYHnqsKRl7dJ3rJaAXOStpZHJSHylxNeVMsSe2j97X/ofVLo7GokT75QE2hY
KM1uVWMEj6hZ8KW/q3kXIjc/DJECAPj4G518TEst7K40jhDsUEJs6jfb5kBcIV5X
bOfiuLBmfGXlagDW1L87Wixt2KlYufbV9QZIIOVxerVRvej///ECAPsZATyCqn4l
z0i0jxVLoRSUgOauEBYQlKHNuKpcmHboIfCPH8MlnnoMKWxgBmQXRMuE2t8g7feA
fH9dvwedfS0B/iz02639mmLfYmfZEd9NgAupLH1uAuv5KraF2kVaoDj1pU4Ihxly
OXe7l267tkYwHGM9ceGQ5cM5GmC2hz3PlKGhZoifBBgBCgAJBQJTDMNcAhsMAAoJ
EPHJCcLcUMjQ4nAD/3M/McdrdU+Gx3iGEjVZA19w+qB7dAMiAPnT1sLybUfh+JSu
3cFFCjkVAUwaBDTO3kPF58gLSACIzKfh2CQa8kKoYMqmnCqEHvv1czn6qT5iHbL5
YDEhwLkqzeffcOhe+vj3HV/jo5ODz8+KjFV+W4YjO2i/owvSwExyL5OXx0Jm
=eaz8
-----END PGP PRIVATE KEY BLOCK-----"

    @hc_pubkey = "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

mI0EUwzDXAEEALZ8utvvTUZIoBQnsgmFFxMXa0bEuoY2uX5gFeW5jaOaMsB1Wmjs
hjJZCxiUC/mQuZat2HNHyydeKCJvbjzgBrBBhQP4ms86EAc2cI1Y2QGgHg+ySXZ2
cA0HWgYU5QlBqGMnZJkVorn52W4vgKeYl/Z9+jf0f5Rb0bEdK/OuuwVhABEBAAG0
K0hpZXJhQ3J5cHRhIFRlc3QgS2V5IDxoaWVyYWNyeXB0YUBkZXYubnVsbD6ItwQT
AQoAIQUCUwzDXAIbAwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRDxyQnC3FDI
0Dy0A/9C2CMm8m7s2D9et218N6cJA6GYEzT+GRIOpi1bh3IC2GqfFh9kxihkFSC+
U5JqDW3lHNxorNxV+6HSDdc/MicmZlwDrL7CtPF4ey1kLIyO8IrCm7noO3kEVOWz
zfSbUiLBaY/dcqCRvHAkT6ZHOnwhRBaf9f2Y4cV/rG11Ml4l/biNBFMMw1wBBAD0
M5SB7JXVBf911LgMvAnbQzx/GSsgDhAmX6x6Y/a2JlKz74HLonM4vRbzEEN082kj
7evekgzobUb6jVMbCqPgP/nmXMz+5nzIohR/1epmLvmmkhvR1hNY6n6t43p4pNp6
UXLEMVVxroUJP+e3Lp6AnGNfQBbfBRr5KX/1gsWqXQARAQABiJ8EGAEKAAkFAlMM
w1wCGwwACgkQ8ckJwtxQyNDicAP/cz8xx2t1T4bHeIYSNVkDX3D6oHt0AyIA+dPW
wvJtR+H4lK7dwUUKORUBTBoENM7eQ8XnyAtIAIjMp+HYJBryQqhgyqacKoQe+/Vz
OfqpPmIdsvlgMSHAuSrN599w6F76+PcdX+Ojk4PPz4qMVX5bhiM7aL+jC9LATHIv
k5fHQmY=
=rY+5
-----END PGP PUBLIC KEY BLOCK-----"

    @example_secret = "-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

hIwDUp5XLw9N87IBBADs/tt8+3cz7pxuUSm5bxQOiM965o8HKNTuj6VVUAwuzlA2
N0IxEaIRN2kM3fCGCWiaYlFHv6Vq3Yn/DW3EU0XOenfDA0SCfy3DMJDfIBxUyyuR
x9Ynpx/KtHWLQBXGEhsOviNz15CTtv+eG17SUsb3dWqaN3tCMhxnz9RpfMzEJ9JY
ATa+0fGN9tprCAsYyS8R55E+sqfqLRz3yYOyQ97Lgl/E8r2Lejeg8K8mkln1bOtw
388VSihqcyOR2i3qM53OPEvyi53lYA1ACTMN1qkPotJdhffd5wxobg==
=1buu
-----END PGP MESSAGE-----"

    @trusted_signed_data="-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

owGbwMvMwMX48STnoTsBJy4wrlFP4ipJrSjRK8hJzMwL5jlyPiQjs1gBJKQApFPz
kosqC0pSU7g65rAwMHIxsLEygRQxcHEKwMzwN2D+X7P3jfdXEfvCH0KhRdlep3ac
mJC7pPLmPdc11zsTYhOXrr2sPnNx3MX/zux+p5riz5xw4fNL5nWLv9i4PuaplBBb
bp2klswc05mXOY7d8FP1fFmgyW2Ue+mEavBHnuTUxuDjPxzDF0vb9/sInhKJD01d
Op9rjb31o2fPeiwiz/f+Uf+x2yodAA==
=L4Fk
-----END PGP MESSAGE-----"

    @untrusted_signed_data="-----BEGIN PGP MESSAGE-----
Version: GnuPG v1

owGbwMvMwMT46d59fvGqA6sY11gnceSlluulZeakBvNsYAjJyCxWAHEUgHRxZnpe
aopCUqVCcX5uan5eqkJ5qkJKfp56iUJ2Xn45VyejDAsDIxMDGysTSC8DF6cAzGCu
bA6GPazZ7WtlmfqDfC+VVv9W8PiqJ9W0zexopIuP5Hrd2CbvFwetrjjIzM1+lei3
lsdgQafJ/601/jrtt+43PdYqNeBL37s8tC+u7kiu07O9UjL8zN4yUiaSd3+Jvi+2
7mtmY4vyid47SejhypfLJnu/bPyuPCmOx2hXMIPyumcs/Vym9w/Nyz520DXXhvNP
dT7/lKwOm/STAkx7H7BwXJdLvjCJ19nmClv9ek3rlyKrUqRMF+hodWnd3mg1rXP5
nvMaS/5JFhybe9fTf97tHL5dAe9Xq/9UWbnPasIqawMftkruyJiqy2ZP3MpFkiWi
d8d8ednfn9mpVrDY0HdRWu45E5abcxffYpJWNrl3BwA=
=zjvk
-----END PGP MESSAGE-----"

    GPGME::Key.import(@hc_privkey)
    GPGME::Key.import(@hc_pubkey)
  end

  def test_decrypt
    secret_data = Hieracrypta::EncryptedData.new(@example_secret)
    assert_equal "This text is encrypted\n", "#{secret_data.decrypt}"
  end

  def test_trust
    secret_data = Hieracrypta::EncryptedData.new(@trusted_signed_data)
    assert_equal true, secret_data.trust_sig?
  end

  def test_untrust
    secret_data = Hieracrypta::EncryptedData.new(@untrusted_signed_data)
    assert_equal false, secret_data.trust_sig?
  end

end
