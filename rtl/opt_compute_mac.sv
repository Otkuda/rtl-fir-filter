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
localparam logic signed [ACC_WIDTH-1:0] ROUND_CONST = (1'b1 << 14);

logic mac_clr_0, mac_clr_1, mac_clr_2;

logic signed [DATA_WIDTH-1:0] i_signal_reg_0, i_signal_reg_1;
logic signed [DATA_WIDTH-1:0] i_coef_reg_0, i_coef_reg_1;
  
logic signed [MULT_WIDTH-1:0] mul_res;
logic signed [ ACC_WIDTH-1:0] acc_res;

logic signed [ ACC_WIDTH-1:0] c; 


always_ff @(posedge clk) begin
  if (rst) begin
    mul_res   <= '0;
    acc_res   <= '0;
    mac_clr_0 <= '0;
    mac_clr_1 <= '0;
    mac_clr_2 <= '0;
    i_signal_reg_0 <= '0;
    i_coef_reg_0 <= '0;
    i_signal_reg_1 <= '0;
    i_coef_reg_1 <= '0;
    o_res <= '0;
  end
  else begin
    // -- Stage 0 - Input copy -- 
    i_signal_reg_0 <= i_signal;
    i_coef_reg_0   <= i_coef;
    mac_clr_0    <= i_mac_clr; 

    i_signal_reg_1 <= i_signal_reg_0;
    i_coef_reg_1   <= i_coef_reg_0;
    mac_clr_1    <= mac_clr_0; 

    // -- Stage 1 - Multiplication --
    mul_res <= i_signal_reg_1 * i_coef_reg_1;
    mac_clr_2 <= mac_clr_1;

    // -- Stage 2 - Addition --
    if (mac_clr_2) begin
      acc_res <= mul_res + ROUND_CONST;
    end
    else begin
      acc_res <= acc_res + mul_res;
    end

    // -- Stage 3 - output --
    if (acc_res[FRAC_WIDTH-1:0] == {FRAC_WIDTH{1'b0}})
      o_res <= {acc_res[ACC_WIDTH-1:FRAC_WIDTH+1], 1'b0}; 
    else
      o_res <= acc_res[ACC_WIDTH-1:FRAC_WIDTH];
  end
end


endmodule