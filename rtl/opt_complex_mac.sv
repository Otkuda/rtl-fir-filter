`timescale 1ns/1ps
(* use_dsp="yes" *)
module opt_complex_mac #(
  DATA_WIDTH = 16
) (
  input logic clk,
  input logic rst,

  input logic signed [DATA_WIDTH*2-1:0] i_signal_complex,
  input logic signed [DATA_WIDTH-1  :0] i_coef_real,

  input  logic i_mac_clr,
  output logic signed [DATA_WIDTH*2-1:0] o_res_complex  
);

localparam MAC_WIDTH = 33;

localparam logic signed[DATA_WIDTH-1:0] MAX_VAL = (DATA_WIDTH)'(2**(DATA_WIDTH-1)-1);
localparam logic signed [DATA_WIDTH-1:0] MIN_VAL = -(DATA_WIDTH)'(2**(DATA_WIDTH-1));

logic signed [MAC_WIDTH-1:0] res [0:1];

genvar i;
generate
  for (i = 0; i < 2; i++) begin
    opt_compute_mac # (
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),
      .i_signal(i_signal_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)]),
      .i_coef(i_coef_real),
      .i_mac_clr(i_mac_clr),
      .o_res(res[i])
    );
    
    logic pos_overflow;
    logic neg_overflow;

    assign pos_overflow = (res[i][MAC_WIDTH-1] == 1'b0) &&  (|res[i][MAC_WIDTH-2 : DATA_WIDTH-1]);
    assign neg_overflow = (res[i][MAC_WIDTH-1] == 1'b1) && (~&res[i][MAC_WIDTH-2 : DATA_WIDTH-1]);

    always_ff @(posedge clk) begin
      if (rst) begin
        o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] <= '0;
      end
      else begin
        if (pos_overflow)
          o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] <= MAX_VAL;
        else if (neg_overflow)
          o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] <= MIN_VAL;
        else
          o_res_complex[DATA_WIDTH*(2-i)-1:DATA_WIDTH*(1-i)] <= res[i][DATA_WIDTH-1:0];
      end
    end
  end

endgenerate

endmodule