import os
from cocotb_tools.runner import get_runner
from pathlib import Path


def test_filter_runner():
  sim = os.getenv("SIM", "questa")
  src_path = Path("../../rtl")

  build_dir = Path("axil_filter_tb_build")
  build_dir.mkdir(exist_ok=True)

  verilog_sources = [
    src_path / "axis_fifo.sv",
    src_path / "control_fsm.sv",
    src_path / "mem_ring_buffer.sv",
    src_path / "opt_complex_mac.sv",
    src_path / "opt_compute_mac.sv",
    src_path / "seq_filter_top.sv",
    src_path / "sync_coef_mem.sv",
    src_path / "axis_fifo.sv",
    src_path / "regblock/fir_addrmap_pkg.sv",
    src_path / "regblock/fir_addrmap.sv",
    src_path / "axi4lite_intf.sv",
    src_path / "fir_axil_slave_adapter.sv",
    src_path / "filter_fifo_wrapper.sv",
  ]

  runner = get_runner(sim)

  runner.build(
    sources=verilog_sources,
    hdl_toplevel="filter_fifo_wrapper",
    build_dir=build_dir,
    build_args=["-lint"],
    always=True
  )

  runner.test(
    hdl_toplevel="filter_fifo_wrapper",
    test_module="axil_filter_tb",
    test_args=["-novopt"],
    waves=True,
    gui=True,
    # pre_cmd=[""]
  )