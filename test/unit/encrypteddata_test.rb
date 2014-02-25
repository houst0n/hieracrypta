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
  end

  def test_decrypt
    result = "#{Hieracrypta::EncryptedData.new.decrypt(@secret)}"
    assert_equal "This text is encrypted\n", result
  end

end
