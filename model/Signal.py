import numpy as np

PI2 = np.pi * 2

def generateSinWave(freq: float, ph0: float, amp: float, fs: int, nSamples=2048, duration=None) -> np.array:
  """
  Генерирует синусоидальный сигнал c заданными параметрами.
  """
  if nSamples == 0 and duration is not None: 
    nSamples = round(fs * duration)
    ts = np.linspace(0.0, duration, nSamples)
  elif duration is None and nSamples != 0:
    ts = np.arange(0, 1/fs * nSamples, 1/fs)
  else:
    return None

  return amp * np.sin(PI2 * freq * ts + ph0)


def generateComplexSinWave(freq: float, ph0: float, amp: float, fs:int, nSamples=2048, duration=None):

  if nSamples == 0 and duration is not None: 
    nSamples = round(fs * duration)
    ts = np.linspace(0.0, duration, nSamples)
  elif duration is None and nSamples != 0:
    ts = np.arange(0, 1/fs * nSamples, 1/fs)
  else:
    return None

  return amp * np.exp(1j * PI2 * freq * ts + ph0)


def generateSquareWave(freq: float, ph0: float, amp: float, fs: int, nSamples=2048, duration=None):
  """
  Генерирует меандр
  """
  if nSamples == 0 and duration is not None: 
    nSamples = round(fs * duration)
    ts = np.linspace(0.0, duration, nSamples)
  elif duration is None and nSamples != 0:
    ts = np.arange(0, 1/fs * nSamples, 1/fs)
  else:
    return None

  return amp * np.sign(np.sin(PI2 * freq * ts + ph0))

def quantizeSignal(signal, maxValue: int, signed=True):
  if signed:
    res = np.clip(np.round(signal, 0), -maxValue, maxValue)
  else:
    res = np.clip(np.round(signal, 0), 0, maxValue)
  return res

def generateAMWave():
  pass


def generateFMWave():
  pass