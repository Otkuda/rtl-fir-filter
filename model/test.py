import numpy as np

def roundToInt16(num):
    """
    Округляет число формата Q15.<presicionBits> в целое число по схеме RoundToEven
    """
    if num == 0:
      return 0

    numBits = bin(num & 0x7fffffff)[2:]
    if len(numBits) < 15:
      return 0

    temp = f"0b{"0" * 16}{numBits[len(numBits)-16]}{(31-16-1) * str(int(numBits[len(numBits)-16])^1)}"
    res = num + int(temp, 2)

    if res < 0:
      return res >> 15
    return  res >> 15


def test_rounding():
  print(f"Testing from {-2**16 / 2 ** 15} to {2 ** 16 / 2**15}")
  for i in range(-2**16, 2**16):
    res = roundToInt16(i)
    assert np.round(i / 2 ** 15, 0) == res