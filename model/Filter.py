# Otkuda, 22.02.26
# Filter.py

import numpy as np

PI2 = np.pi * 2

class FIRFilter:
  
  def __init__(self, coefs, fs):
    self.coefs = np.array(coefs)
    self.depth = len(coefs) + 1
    self.fs    = fs
  

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

  def filterSignal(self, signal):
    res = [np.sum(signal[i-self.depth+1:i] * self.coefs) for i in range(self.depth-1, len(signal))]
    return res

