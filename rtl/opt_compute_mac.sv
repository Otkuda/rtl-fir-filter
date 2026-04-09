`timescale 1ns/1ps

/*
  Pipelined MAC 
*/
(* use_dsp = "yes" *)
(* dsp_folding = "yes" *)
module opt_compute_mac #(
  DATA_WIDTH = 16
) (
  input  clk,
  input  rst,

  input  logic signed [DATA_WIDTH-1:0] i_signal,
  input  logic signed [DATA_WIDTH-1:0] i_coef,

  output logic signed [47:0] o_res,
  input  logic i_mac_clr

);

localparam MULT_WIDTH  = DATA_WIDTH * 2;
localparam FRAC_WIDTH  = DATA_WIDTH - 1; // without sign bit
localparam ACC_WIDTH   = 48;  // accumulator as in DSP48E1

logic mac_clr_0, mac_clr_1;

logic signed [DATA_WIDTH-1:0] i_signal_reg;
logic signed [DATA_WIDTH-1:0] i_coef_reg;
  
logic signed [MULT_WIDTH-1:0] mul_res;
logic signed [ ACC_WIDTH-1:0] acc_res;

logic pattern_detect;
logic signed [ ACC_WIDTH-1:0] c; 
logic signed [ ACC_WIDTH-1:0] pre_acc;

assign c       = { 34'b0, 14'b11111111111111 };
assign pre_acc = mac_clr_1 ? (mul_res + c + 48'sd1) : (mul_res + acc_res);

always_ff @(posedge clk) begin
  if (rst) begin
    mul_res   <= '0;
    acc_res   <= '0;
    pattern_detect <= '0;
    mac_clr_0 <= '0;
    mac_clr_1 <= '0;
    i_signal_reg <= '0;
    i_coef_reg <= '0;
    o_res <= '0;
  end
  else begin
    // -- Stage 0 - Input copy -- 
    i_signal_reg <= i_signal;
    i_coef_reg   <= i_coef;
    mac_clr_0    <= i_mac_clr; 

    // -- Stage 1 - Multiplication --
    mul_res <= i_signal_reg * i_coef_reg;
    mac_clr_1 <= mac_clr_0;

    // -- Stage 2 - Addition --
    acc_res <= pre_acc;
    pattern_detect <= (pre_acc[FRAC_WIDTH-1:0] == {FRAC_WIDTH{1'b0}});

    // -- Stage 3 - output --
    if (pattern_detect)
      o_res <= {acc_res[ACC_WIDTH-1:FRAC_WIDTH+1], 1'b0}; 
    else
      o_res <= acc_res[ACC_WIDTH-1:FRAC_WIDTH];
  end
end


endmodule