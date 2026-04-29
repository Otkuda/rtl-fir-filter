module filter_fifo_wrapper #(
  SIG_WIDTH = 16,
  DATA_WIDTH = 32,
  ADDR_WIDTH = 32,
  DEPTH = 128
) (
  input logic clk,
  input logic rst,

  input  logic [SIG_WIDTH*2-1:0]   s_axis_tdata,
  input  logic                    s_axis_tvalid,
  output logic                    s_axis_tready,

  output logic [SIG_WIDTH*2-1:0]   m_axis_tdata,
  output logic                    m_axis_tvalid,
  input  logic                    m_axis_tready,

  input  logic                    s_axil_awvalid,
  input  logic [ADDR_WIDTH - 1:0] s_axil_awaddr,
  input  logic [2:0]              s_axil_awprot,
  output logic                    s_axil_awready,

  input  logic                    s_axil_wvalid,
  input  logic [DATA_WIDTH - 1:0] s_axil_wdata,
  input  logic [DATA_WIDTH/8-1:0] s_axil_wstrb,
  output logic                    s_axil_wready,

  input  logic                    s_axil_bready,
  output logic                    s_axil_bvalid,
  output logic [1:0]              s_axil_bresp,

  input  logic                    s_axil_arvalid,
  input  logic [ADDR_WIDTH - 1:0] s_axil_araddr,
  input  logic [2:0]              s_axil_arprot,
  output logic                    s_axil_arready,

  input  logic                    s_axil_rready,
  output logic [DATA_WIDTH - 1:0] s_axil_rdata,
  output logic [1:0]              s_axil_rresp,
  output logic                    s_axil_rvalid

);

localparam COMPLEX_WIDTH = SIG_WIDTH * 2;

logic [COMPLEX_WIDTH-1:0] axis_i_signal_tdata;
logic                     axis_i_signal_tvalid;
logic                     axis_i_signal_tready;

logic [COMPLEX_WIDTH-1:0] axis_o_signal_tdata;
logic                     axis_o_signal_tvalid;
logic                     axis_o_signal_tready;

logic [$clog2(DEPTH)-1:0] coef_mem_addr;
logic [    SIG_WIDTH-1:0] coef_mem_data;
logic                     coef_mem_wren;

logic  [$clog2(DEPTH)-1:0] curr_depth; 

fir_axil_slave_adapter adapter_inst (
  .i_clk(clk),
  .i_rst(rst),

  .i_awvalid(s_axil_awvalid),
  .i_awaddr (s_axil_awaddr),
  .i_awprot (s_axil_awprot),
  .o_awready(s_axil_awready),

  .i_wvalid(s_axil_wvalid),
  .i_wdata (s_axil_wdata),
  .i_wstrb (s_axil_wstrb),
  .o_wready(s_axil_wready),

  .i_bready(s_axil_bready),
  .o_bvalid(s_axil_bvalid),
  .o_bresp (s_axil_bresp),

  .i_arvalid(s_axil_arvalid),
  .i_araddr (s_axil_araddr),
  .i_arprot (s_axil_arprot),
  .o_arready(s_axil_arready),

  .i_rready (s_axil_rready),
  .o_rdata  (s_axil_rdata),
  .o_rresp  (s_axil_rresp),
  .o_rvalid (s_axil_rvalid),

  .i_csr(),
  .o_we_strb(coef_mem_wren),
  .o_mem_addr(coef_mem_addr),
  .o_mem_data(coef_mem_data),
  .o_filter_depth(curr_depth)
);

axis_fifo #(
  .DEPTH(DEPTH),
  .WIDTH(COMPLEX_WIDTH)
) input_fifo_inst (
  .clk(clk),
  .rst(rst),
  .s_axis_tdata (s_axis_tdata),
  .s_axis_tvalid(s_axis_tvalid),
  .s_axis_tready(s_axis_tready),

  .m_axis_tdata (axis_i_signal_tdata),
  .m_axis_tvalid(axis_i_signal_tvalid),
  .m_axis_tready(axis_i_signal_tready)
);

seq_filter_top #(
  .DEPTH(DEPTH),
  .DATA_WIDTH(SIG_WIDTH),
  .OPT_DSP_ENA(1)
) filter_inst (
  .clk(clk),
  .rst(rst),

  .s_axis_dl_tdata (axis_i_signal_tdata),
  .s_axis_dl_tvalid(axis_i_signal_tvalid),
  .s_axis_dl_tready(axis_i_signal_tready),

  .wren(coef_mem_wren),
  .w_coef_data(coef_mem_data),
  .w_coef_addr(coef_mem_addr),
  
  .filter_depth(curr_depth),
  
  .m_axis_mac_tdata (axis_o_signal_tdata),
  .m_axis_mac_tvalid(axis_o_signal_tvalid),
  .m_axis_mac_tready(axis_o_signal_tready)
);


axis_fifo #(
  .DEPTH(DEPTH),
  .WIDTH(COMPLEX_WIDTH)
) output_fifo_inst (
  .clk(clk),
  .rst(rst),

  .s_axis_tdata (axis_o_signal_tdata),
  .s_axis_tvalid(axis_o_signal_tvalid),
  .s_axis_tready(axis_o_signal_tready),

  .m_axis_tdata (m_axis_tdata ),
  .m_axis_tvalid(m_axis_tvalid),
  .m_axis_tready(m_axis_tready)
);

endmodule