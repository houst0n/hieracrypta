require 'hieracrypta'
require 'test/unit'

class EncryptedDataTest < Test::Unit::TestCase

  def initialize (args)
    super(args)
    @secret = "-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

hQEMA7wrqvDlYVcQAQf/QdxPU1Lp6jMF834j+6UWdz9KEpSIBRteVkSuRTqkJp0u
PPTb+L9z204m+qXjRKhc/zSyDX2/7zaVijODIWJvtT/pHwSypumkyfQpNsnkLOZd
krcwdvqCIiewfw9wrY5g95BJ0/dQRnCPAGsBVH4ckL6gDkr0nNf0E4Bpsr8V0y2O
Bq1edX2R7qFd1Z4CEVXzNL6Ka4BFDhQjNKkPRbUwiEu7zqfqcoqCuqSFsp7oKA1M
decTi1tQAdBj4NX+ib27cRCn0d5o2h1AMrRzOf6RWIzkIyfqxJhn13WHLRCvXT92
WOYzngsbIFNEWm2rxfJVEbQBMVKYskuD9TX4MfjpgoUBDANkK0RjnhIgnwEH/2y+
FFOVSC/k1WqI+bU3DVbu+k3pgs5pusCcLuLpfF02uajNlUllVeJtWraCX0aguWE9
EvilXnxGQq0dD9uDK9uvyZoLIItEClIRW/+b6vF3dwo+D+v0qNQ02m6GLeYNlJUg
I3QgfRQB2R2Wy/2Nxk76FJ4WY1NHRWVcpxRFQpKrIuR7I4gNAiqFchwtj/izn3Aj
swUj6qqalUNNAVGH9t/XxNUovqmvI7W2tsYLKa/vWYEPbt52gUdxM3voUUTl9GKI
7roaiPbnQZrPoqLmY+tU9qy+bTxHVwRaIosqCvspAve2VK+iIfG0V9yX+7t8XKiV
WRWYgnu58bg1th6+kC3SwMMBOFjeHT6Z+0YGHZiW1ATJd7V3nQoZxFvlKif1H0TA
K0/Jid08pyw0kDSG0PZ3ov7UeX0iRGV/0tsalkzzF+LrjATfKV1rflF6t//ix+3/
/Z5ZbJXRy/oywYYR16UhYXh34nsxGfI74z3HBDkCJs6WCvgbMgj4lp9xlcbQ0Xm9
7PaYCRXK3GkOUO7Neq08LPp8E+XGHGH0i77LpJIKQu1028lxrzqWkplNofxUkGXC
C9EUsqPjaVMd0/Q8ONNPbwxAL7g6iWQBpwI3CHAUU0L0Nez5bhAKcCY7Cba+Pp/0
cw2P07dzp0Zl8JHh8kzR675lHjZZUxn8IyFNFMUm4YepOo03ydXHyTL2AcNDrqsB
PbSBPfXumqcq66h76OPLelZk9tH4BnyTLZw1tuulbuDSbOPjCajaGSVwmtdzWNBo
eYOyHs/jibu58jPZFz1JtAjnR0qmAv4BaVBz0nVZw8pQDts259KmGW147PYD1oJP
ve3T8gLzIsPTvJjiBl2Kr72s9ME=
=4qB2
-----END PGP MESSAGE-----"

    @trusted_signed_data="-----BEGIN PGP MESSAGE-----
Version: GnuPG v1

owEBUwKs/ZANAwACAZE2BqOG/J1kAawjYgl0ZXN0LmZpbGVTDK5qVGhpcyBpcyBh
IHRlc3QgZmlsZQqJAhwEAAECAAYFAlMMrmoACgkQkTYGo4b8nWQHmxAAi6Ty6ChJ
f9fr3kSpudKiqtcJh3dRK5EEvWwqwR1EbrxX7ikW6fYS9nHp13lQSmRtcxA7O511
nEhIERYEPq8HuqAOio33kjhgxN8/gvB+DGDdSv6CZWJZObIyXmprc+PNgk/FbYxi
bZwra/D9RitpvWF9nQNA4AKkQ9nLvXkNpU8M0eEvverWLCvdQEPTt0Lwos8rdqxL
E5ATp8IdPdZ/rvdmMOvzhCQC4bCvt4XlCBekA9W/i8/jB4y17IRVof2z0pq574yM
Yrup6s8njkrirr1RoajnYYWPC3AiGJVc0vMPMpD/H4oTNH0EPRKalJ0G/ZakE/5q
Bv9Ued12a7qhTNU0DWCLzWmcRQFp9bTyjOJ3BAOjR8jlD/4gzB4bWEvDJq+D5R4q
mUoixRHlR2Ng2bfb+p0zWQie04iEMZhkhXuU2lcdyKAACuvMJU3mp0WXS5/TEQLT
X31nx1GMuFQQMOkW5XE2S+h3XRN/bHfQw/V7Gx1CFxalfjexHaOp5WPhvhA9ai0t
MQ0ASSsZg0aYoYc/0FKLYtdbqqRNy1C+gTFVjWTeCHnTy5gq6bgBz2pPYQ07A8uH
UBxFRXlS5tx13tAtx6NdCtIdhdVlOKUqMmbfv5V9sc17+18o2MQBSMyV16VEluOh
RyMVTZHouBlmnzIlv0q2xPD9rH3lC209awc=
=Z51C
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
  end

  def test_decrypt
    secret_data = Hieracrypta::EncryptedData.new(@secret)
    assert_equal "This text is encrypted\n", "#{secret_data.decrypt}\n"
  end

  def test_trust
    secret_data = Hieracrypta::EncryptedData.new(@trusted_signed_data)
    assert_equal false, secret_data.trust_sig?
  end

  def test_untrust
    secret_data = Hieracrypta::EncryptedData.new(@untrusted_signed_data)
    assert_equal false, secret_data.trust_sig?
  end

end
