module filter_fifo_wrapper #(
  DATA_WIDTH = 16,
  DEPTH = 128
) (
  input logic clk,
  input logic rst,

  input  logic [DATA_WIDTH*2-1:0] s_axis_tdata,
  input  logic                    s_axis_tvalid,
  output logic                    s_axis_tready,

  output logic [DATA_WIDTH*2-1:0] m_axis_tdata,
  output logic                    m_axis_tvalid,
  input  logic                    m_axis_tready,

  input  logic [$clog2(DEPTH)-1:0] i_coef_mem_addr,
  input  logic [   DATA_WIDTH-1:0] i_coef_mem_data,
  input  logic                     i_coef_mem_wren,

  input logic  [$clog2(DEPTH)-1:0] i_curr_depth 

);

localparam COMPLEX_WIDTH = DATA_WIDTH * 2;

logic [COMPLEX_WIDTH-1:0] axis_i_signal_tdata;
logic                     axis_i_signal_tvalid;
logic                     axis_i_signal_tready;

logic [COMPLEX_WIDTH-1:0] axis_o_signal_tdata;
logic                     axis_o_signal_tvalid;
logic                     axis_o_signal_tready;

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
  .DATA_WIDTH(DATA_WIDTH),
  .OPT_DSP_ENA(1)
) filter_inst (
  .clk(clk),
  .rst(rst),

  .s_axis_dl_tdata (axis_i_signal_tdata),
  .s_axis_dl_tvalid(axis_i_signal_tvalid),
  .s_axis_dl_tready(axis_i_signal_tready),

  .wren(i_coef_mem_wren),
  .w_coef_data(i_coef_mem_data),
  .w_coef_addr(i_coef_mem_addr),
  
  .filter_depth(i_curr_depth),
  
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