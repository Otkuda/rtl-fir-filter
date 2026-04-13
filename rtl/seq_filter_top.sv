module seq_filter_top #(
  DEPTH = 128,
  DATA_WIDTH = 16,
  OPT_DSP_ENA  = 1,
  SYNC_MEM_ENA = 1
) (
  input logic clk,
  input logic rst,

  // Signal interface
  input  logic [DATA_WIDTH*2-1:0] s_axis_dl_tdata,
  input  logic                    s_axis_dl_tvalid,
  output logic                    s_axis_dl_tready,

  // Memory interface
  input logic wren,
  input logic [   DATA_WIDTH-1:0] w_coef_data,
  input logic [$clog2(DEPTH)-1:0] w_coef_addr,

  // FSM input
  input logic [$clog2(DEPTH)-1:0] filter_depth,

  // Result interface
  output logic [DATA_WIDTH*2-1:0] m_axis_mac_tdata,
  output logic                    m_axis_mac_tvalid,
  input  logic                    m_axis_mac_tready
);

logic dl_ena;
logic [$clog2(DEPTH)-1:0] dl_r_addr;
logic [ DATA_WIDTH*2-1:0] dl_signal;

logic [$clog2(DEPTH)-1:0] r_coef_addr;
logic [   DATA_WIDTH-1:0] r_coef_data;

logic res_valid;
logic mac_clr;

control_fsm #(
  .DEPTH(DEPTH),
  .OPT_DSP_ENA(OPT_DSP_ENA),
  .SYNC_MEM_ENA(SYNC_MEM_ENA)
) fsm_inst (
  .clk(clk),
  .rst(rst),
  
  .i_c_depth(filter_depth),

  .i_fifo_valid(s_axis_dl_tvalid),
  .o_dl_ena    (dl_ena),
  .o_dl_addr   (dl_r_addr),

  .o_cmem_addr(r_coef_addr),

  .i_res_fifo_ready(m_axis_mac_tready),
  .o_res_valid(res_valid),
  .o_mac_clr(mac_clr)
);

generate
  if (SYNC_MEM_ENA) begin
    mem_ring_buffer # (
      .DATA_WIDTH(DATA_WIDTH*2),
      .DEPTH(DEPTH)
    ) sync_dl_inst (
      .clk(clk),
      .rst(rst),

      .s_axis_tdata (s_axis_dl_tdata),
      .s_axis_tvalid(s_axis_dl_tvalid),
      .s_axis_tready(s_axis_dl_tready),
      
      .ena(dl_ena),
      .r_addr(dl_r_addr),
      .out_data(dl_signal)
    );

    sync_coef_mem #(
      .DEPTH(DEPTH),
      .DATA_WIDTH(DATA_WIDTH)
    ) coef_mem_inst (
      .clk(clk),

      .wren(wren),
      .w_addr(w_coef_addr),
      .w_data(w_coef_data),
      .r_addr(r_coef_addr),
      .r_data(r_coef_data)
    );

  end
  else begin
    delay_line #(
      .DATA_WIDTH(DATA_WIDTH*2),
      .DEPTH(DEPTH)
    ) dl_inst (
      .clk(clk),
      .rst(rst),

      .s_axis_tdata (s_axis_dl_tdata),
      .s_axis_tvalid(s_axis_dl_tvalid),
      .s_axis_tready(s_axis_dl_tready),
      
      .ena(dl_ena),
      .addr(dl_r_addr),
      .out_data(dl_signal)
    );

    coef_mem #(
      .DATA_WIDTH(DATA_WIDTH),
      .DEPTH(DEPTH)
    ) cmem_inst (
      .clk(clk),
      .rst(rst),

      .wren(wren),
      .w_addr(w_coef_addr),
      .w_data(w_coef_data),
      .r_addr(r_coef_addr),
      .r_data(r_coef_data)
    );
  end
endgenerate

generate
  if (OPT_DSP_ENA) begin
    opt_complex_mac #(
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),

      .i_signal_complex(dl_signal),
      .i_coef_real(r_coef_data),

      .i_mac_clr(mac_clr),
      .o_res_complex(m_axis_mac_tdata)
    );
  end
  else begin
    complex_mac #(
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),

      .i_signal_complex(dl_signal),
      .i_coef_real(r_coef_data),

      .i_mac_clr(mac_clr),
      .o_res_complex(m_axis_mac_tdata)
    );
  end
endgenerate

assign m_axis_mac_tvalid = res_valid;

endmodule