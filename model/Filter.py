# Otkuda, 22.02.26
# Filter.py

import numpy as np

PI2 = np.pi * 2

class FIRFilter:
  """
    Класс КИХ-фильтра. Имеет представление коэффициентов в формате с плавающей запятой и фиксированной запятой Q0.<precisionBits>
  """
  
  def __init__(self, coefs, fs, precision):
    self.coefs = np.array(coefs)
    self.depth = len(coefs) + 1
    self.fs    = fs
    self.precisionBits = precision
    self.fixedCoeffs = self.__convertToFixed()

  
  def __convertToFixed(self):
    return np.clip(np.round(self.coefs * 2 ** self.precisionBits - 1, 0), -(2 ** self.precisionBits), 2 ** self.precisionBits - 1)
  

  def getAFR(self, n_samples):
    fNorm = np.linspace(0, 1, n_samples)
    js = np.arange(len(self.coefs))
    trigArg = PI2 * np.outer(fNorm, js)
    cosSum = np.dot(np.cos(trigArg), self.coefs.reshape((len(self.coefs), 1))) 
    sinSum = np.dot(np.sin(trigArg), self.coefs.reshape((len(self.coefs), 1)))

    afr = np.sqrt(cosSum ** 2 + sinSum ** 2)
    return afr


  def getPFR(self, n_samples):
    fNorm = np.linspace(0, 1, n_samples)
    js = np.arange(len(self.coefs))
    trigArg = PI2 * np.outer(fNorm, js)
    cosSum = np.dot(np.cos(trigArg), self.coefs.reshape((len(self.coefs), 1))) 
    sinSum = np.dot(np.sin(trigArg), self.coefs.reshape((len(self.coefs), 1)))

    pfr = np.arctan(sinSum / cosSum)
    return pfr


  def getImpulseResponse(self, n):
    imp = np.zeros(n)
    imp[n//2] = 1
    return self.filterSignal(imp)


  def getStepResponse(self, n):
    step = np.zeros(n)
    step[n//2:] = 1
    return self.filterSignal(step)


  def filterSignal(self, signal):
    res = np.array([np.sum(signal[i-self.depth+1:i] * self.coefs[::-1]) for i in range(self.depth-1, len(signal))])
    return res

  
  def filterFixedSignal(self, signal):
    if "complex" in str(signal.dtype):
      res = np.zeros(len(signal)-self.depth+1, dtype="complex128")
      for i in range(self.depth-1, len(signal)):
        signalPart = signal[i-self.depth+1:i]
        for j in range(len(signalPart)):
          coef = int(self.fixedCoeffs[-(j+1)])
          tempReal = int(signalPart[j].real) * coef
          tempImag = int(signalPart[j].imag) * coef

          res[i-self.depth+1] += self.__roundToInt16(tempReal) + self.__roundToInt16(tempImag) * 1j
    else:
      res = np.zeros(len(signal)-self.depth+1)
      for i in range(self.depth-1, len(signal)):
        signalPart = signal[i-self.depth+1:i]
        for j in range(len(signalPart)):
          coef = int(self.fixedCoeffs[-(j+1)])
          temp = int(signalPart[j]) * coef

          res[i-self.depth-1] += self.__roundToInt16(temp)
    
    return res

  def __roundToInt16(self, num):
    """
    Округляет число формата Q15.<presicionBits> в целое число по схеме RoundToEven
    """
    if num == 0:
      return 0

    numBits = bin(num & 0x7fffffff)[2:]
    if len(numBits) < 16:
      return 0

    temp = f"0b{"0" * 16}{numBits[len(numBits)-16]}{(31-16-1) * str(int(numBits[len(numBits)-16])^1)}"
    res = num + int(temp, 2)

    if res < 0:
      return -(-res >> self.precisionBits)
    return  res >> self.precisionBits


