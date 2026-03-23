`timescale 1ns/1ps

/*
  Pipelined MAC 
*/
module compute_mac #(
  DATA_WIDTH = 16
) (
  input  clk,
  input  rst,

  input  logic signed [DATA_WIDTH-1:0] i_signal,
  input  logic signed [DATA_WIDTH-1:0] i_coef,

  output logic signed [(DATA_WIDTH+8)-1:0] o_res,
  input  logic i_res_valid

);

localparam MULT_WIDTH  = DATA_WIDTH * 2 - 1; 
localparam MAC_WIDTH   = (DATA_WIDTH + 8) - 1;  // extra bits for addition carry 
  
logic signed [MULT_WIDTH-1:0] mul_res;
logic signed [ MAC_WIDTH-1:0] mac_res;
logic signed [DATA_WIDTH-1:0] round_res;

logic [MULT_WIDTH:0] pre_round;

assign pre_round = mul_res + { {(DATA_WIDTH){1'b0}}, 
                               mul_res[MULT_WIDTH-DATA_WIDTH],
                              {(MULT_WIDTH-DATA_WIDTH-1){!mul_res[MULT_WIDTH-DATA_WIDTH]}} };

always_ff @(posedge clk) begin
  if (rst) begin
    mul_res   <= '0;
    mac_res   <= '0;
    round_res <= '0;
  end
  else begin
    // -- Stage 1 - Multiplication --
    mul_res <= i_signal * i_coef;

    // -- Stage 2 - Rounding -- 
    round_res <= pre_round[MULT_WIDTH-1:MULT_WIDTH-DATA_WIDTH];

    // -- Stage 3 - Addition --
    if (i_res_valid) begin
      mac_res <= round_res;
    end
    else begin
      mac_res <= mac_res + round_res;
    end
  end
end

assign o_res = mac_res;

endmodule

