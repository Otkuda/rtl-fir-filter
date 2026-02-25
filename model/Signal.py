import numpy as np

PI2 = np.pi * 2

def generateSinWave(freq: float, ph0: float, amp: float, fs: int, duration=1.0) -> np.array:
  """
  Генерирует синусоидальный сигнал c заданными параметрами.

  """
  n = round(fs * duration)
  ts = np.linspace(0.0, duration, n)
  return amp * np.sin(PI2 * freq * ts + ph0)


def generateSquareWave(freq: float, ph0: float, amp: float, fs: int, duration=1.0):
  """
  Генерирует меандр
  """
  n = round(fs * duration)
  ts = np.linspace(0.0, duration, n)

  return amp * np.sign(np.sin(PI2 * freq * ts + ph0))