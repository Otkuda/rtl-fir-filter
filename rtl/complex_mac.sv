`timescale 1ns/1ps
module complex_mac #(
  DATA_WIDTH = 16
) (
  input logic clk,
  input logic rst,

  input logic signed [DATA_WIDTH*2-1:0] i_signal_complex,
  input logic signed [DATA_WIDTH-1  :0] i_coef_real,

  input  logic i_mac_clr,
  output logic signed [DATA_WIDTH*2-1:0] o_res_complex  
);

logic signed [DATA_WIDTH+7-1:0] res [0:1];

genvar i;
generate
  for (i = 0; i < 2; i++) begin
    compute_mac # (
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),
      .i_signal(i_signal_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)]),
      .i_coef(i_coef_real),
      .i_mac_clr(i_mac_clr),
      .o_res(res[i])
    );

    always_comb begin
      if (res[i] > 23'sd32767)
        o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] = 16'sd32767;
      else if (res[i] < -23'sd32768)
        o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] = -16'sd32768;
      else
        o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] = res[i][DATA_WIDTH-1:0];
    end
  end

endgenerate

endmodule