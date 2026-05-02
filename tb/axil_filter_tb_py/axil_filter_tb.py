import cocotb
from cocotb.types import LogicArray
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, Event, First
from cocotb.handle import Immediate
from cocotbext.axi import AxiLiteBus, AxiLiteMaster

import logging
from scipy.signal import firwin
import numpy as np
import matplotlib.pyplot as plt
import random

from model.Filter import FIRFilter
from model.Signal import generateComplexSinWave, quantizeSignal

CLK_PER = 10

class TB():
  """
  Wrapper class to control DUT signals
  """
  def __init__(self, dut, nTaps: int, cutoffFreq: int | list[int], lowpass: bool, fs: int, precBits=15):
    self.dut = dut

    self.nFilterTaps = nTaps
    self.cutoffFreq = cutoffFreq
    self.lowpass = lowpass
    self.fs = fs
    self.precBits = precBits

    if lowpass:
      self.filt = FIRFilter(self.__genLowpassCoefs(self.nFilterTaps, self.cutoffFreq, self.fs), self.precBits)
    else:
      self.filt = FIRFilter(self.__genBandstopCoefs(self.nFilterTaps, self.cutoffFreq, self.fs), self.precBits)


    # setup logger to print everyting in stdout :p
    self.logger = logging.getLogger("TB")
    self.logger.setLevel(logging.DEBUG)

    # Initialize inputs as 0
    dut.clk.value = Immediate(0)
    dut.rst.value = Immediate(0)

    dut.s_axis_tdata.value = Immediate(0)
    dut.s_axis_tvalid.value = Immediate(0)

    dut.m_axis_tready.value = Immediate(0)

    dut.s_axil_awvalid.value = Immediate(0)
    dut.s_axil_awaddr.value = Immediate(0)
    dut.s_axil_awprot.value = Immediate(0)

    dut.s_axil_wvalid.value = Immediate(0)
    dut.s_axil_wdata.value = Immediate(0)
    dut.s_axil_wstrb.value = Immediate(0)
    
    dut.s_axil_bready.value = Immediate(0)

    dut.s_axil_arvalid.value = Immediate(0)
    dut.s_axil_araddr.value = Immediate(0)
    dut.s_axil_arprot.value = Immediate(0)

    dut.s_axil_rready.value = Immediate(0)

    self.axilMaster = AxiLiteMaster(AxiLiteBus.from_prefix(dut, "s_axil"), dut.clk, dut.rst)

    # Start clock generation coroutine
    cocotb.start_soon(Clock(dut.clk, CLK_PER, "ns").start())


  def __genLowpassCoefs(self, nTaps, cutoffFreq, fs):
    return firwin(nTaps, cutoffFreq, fs=fs)


  def __genBandstopCoefs(self, nTaps, cutoffFreq, fs):
    return firwin(nTaps, cutoffFreq, fs=fs)

  
  def genSignal(self, sigParts: dict[int, int], nSamples):
    signal = np.zeros((nSamples, ), dtype=np.complex128)
    for (f, amp) in sigParts.items():
      signal += generateComplexSinWave(f, 0, amp, self.fs, nSamples)
    
    signal = quantizeSignal(signal, 2**15)
    return signal


  async def init(self):
    await self.reset()


  async def reset(self):
    self.dut.rst.value = 1
    await Timer(CLK_PER * 2, "ns")
    self.dut.rst.value = 0

  
  async def load_IR(self, ir=None):
    self.dut.m_axis_tready.value = 1
    if ir is None:
      ir = self.filt.fixedCoeffs

    await RisingEdge(self.dut.clk)
    await self.axilMaster.write(0x100, len(ir).to_bytes(4, "little"))
    addr = 0
    for el in ir:
      await self.axilMaster.write(0x104, addr.to_bytes(4, "little") )
      await self.axilMaster.write(0x108, int(el).to_bytes(4, "little") )
      await self.axilMaster.write(0x10C, (1).to_bytes(1, "little"))
      addr += 1
      await RisingEdge(self.dut.clk)


  async def pass_signal(self, signal):
    await RisingEdge(self.dut.clk)
    self.dut.s_axis_tvalid.value = 1 
    for el in signal:
      self.dut.s_axis_tdata.value = (el << 16)
      while True:
        await RisingEdge(self.dut.clk)
        if self.dut.s_axis_tready.value == 1:
          break
    self.dut.s_axis_tvalid.value = 0


  async def passComplexSignal(self, signal):
    await RisingEdge(self.dut.clk)
    self.dut.s_axis_tvalid.value = 1 
    for el in signal:
      r = LogicArray.from_signed(int(el.real), 16)
      im = LogicArray.from_signed(int(el.imag), 16)
      self.dut.s_axis_tdata.value = str(r) + str(im)
      while True:
        await RisingEdge(self.dut.clk)
        if self.dut.s_axis_tready.value == 1:
          break
    self.dut.s_axis_tvalid.value = 0


  async def mon_output(self, event: Event):
    result = []
    resValid = RisingEdge(self.dut.m_axis_tvalid)
    ev = event.wait()
    while True:
      trig = await First(resValid, ev)
      if trig is ev:
        break
      elif trig is resValid:
        await Timer(1, "ns")
        result.append(self.dut.m_axis_tdata.value)
    self.logger.debug("Mon Stop")
    self.dut.m_axis_tready.value = 0
    return result


  def checkResult(self, goldenSignal, collectedSig):
    filteredSignal = []
    for el in collectedSig:
      val = el[31:16].to_signed() + 1j * el[15:0].to_signed()
      filteredSignal.append(val)
    filteredSignal = np.array(filteredSignal[self.nFilterTaps-1:])
    assert np.all(filteredSignal == goldenSignal), "Unexpected Result"


@cocotb.test()
async def test_IR(dut):
  tb = TB(dut, 8, 1000, True, 50000)
  tb.dut.m_axis_tready.value = 1
  await tb.init()
  await tb.load_IR()
  await Timer(100, "ns")
  ev = Event()
  cocotb.start_soon(tb.mon_output(ev))
  await tb.pass_signal([0, 0, 0, 0, 0, 2**15-1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  await Timer(5000, "ns")
  tb.dut.m_axis_tready.value = 0
  ev.set()
  await Timer(100, "ns")


@cocotb.test(
  skip=True
)
@cocotb.parametrize(
  (("nTaps", "lowpass", "cutoffFreq"), 
   [ (8,   True, 1000),
     (26,  True, 1000),
     (79,  True, 1000),
     (127, True, 1000), 
     (7,  False, [1000, 10000]), 
     (15, False, [1000, 10000]),
     (31, False, [1000, 10000]), 
     (63, False, [1000, 10000]) 
    ]
  ),
)
async def test_golden_signal(dut, nTaps: int, lowpass: bool, cutoffFreq):
  # signal parameters
  freqParts = {}
  f = 0
  for _ in range(random.randint(1, 10)):
    f += random.randint(100, 2500)
    freqParts[f] = random.randint(1, 8)
  nSamples = random.randint(256, 1024)
  fs = random.randint(25000, 75000)

  # start tb
  tb = TB(dut, nTaps, cutoffFreq, lowpass, fs)
  await tb.init()
  evStop = Event()

  signal = tb.genSignal(freqParts, nSamples) # generate signal
  filteredSignal = tb.filt.filterFixedSignal(signal) # get golden signal

  await tb.load_IR() # load coefs
  await Timer(CLK_PER * 10, "ns") 

  mon_task = cocotb.start_soon(tb.mon_output(evStop)) # start monitor in background
  await tb.passComplexSignal(signal) # pass signal in main routine
  evStop.set() # stop monitor
  colSig = await mon_task # get monitor result

  tb.checkResult(filteredSignal, colSig) # compare results


