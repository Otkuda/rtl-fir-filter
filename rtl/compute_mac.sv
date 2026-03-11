`timescale 1ns/1ps

/*
  Pipelined MAC (complex*real)+complex
*/
module compute_mac #(
  DATA_WIDTH = 16
) (
  input  clk,
  input  rst,

  input  logic        [DATA_WIDTH*2-1:0] i_signal_complex, // {real, imag}
  input  logic signed [DATA_WIDTH-1:0]   i_coef_real,

  input  logic        [DATA_WIDTH*2-1:0] i_adder_complex,

  output logic [DATA_WIDTH*2-1:0] o_res_complex

);

localparam MULT_WIDTH  = DATA_WIDTH * 2;
  
logic signed [DATA_WIDTH-1:0] signal_real, signal_imag;

logic signed [MULT_WIDTH-1:0] mul_res_real, mul_res_imag;

logic signed [DATA_WIDTH-1:0] adder_real_0, adder_real_1;
logic signed [DATA_WIDTH-1:0] adder_imag_0, adder_imag_1;

logic signed [MULT_WIDTH-1:0] mac_res_real, mac_res_imag;
logic signed [MULT_WIDTH-1:0] round_res_real, round_res_imag;

logic [MULT_WIDTH-1:0] pre_round_real, pre_round_imag;

assign signal_real = i_signal_complex[DATA_WIDTH*2-1:DATA_WIDTH]; 
assign signal_imag = i_signal_complex[DATA_WIDTH-1:0];

assign pre_round_real = mac_res_real + { {(DATA_WIDTH){1'b0}}, 
                                          mac_res_real[MULT_WIDTH-DATA_WIDTH-1],
                                          {(MULT_WIDTH-DATA_WIDTH-1){!mac_res_real[MULT_WIDTH-DATA_WIDTH-1]}} };

always_ff @(posedge clk) begin : real_part
  if (rst) begin
    mul_res_real <= '0;
    adder_real_0   <= '0;
  end
  else begin
    // -- Stage 1 - Multiplication --
    mul_res_real <= signal_real * i_coef_real;
    adder_real_0 <= i_adder_complex[DATA_WIDTH*2-1:DATA_WIDTH];

    // -- Stage 2 - Addition --
    mac_res_real <= mul_res_real + { adder_real_0, {(DATA_WIDTH-1){1'b0}} };

    // -- Stage 3 - Rounding -- 
    round_res_real <= pre_round_real[MULT_WIDTH-1:MULT_WIDTH-DATA_WIDTH-1];

  end
end : real_part


assign pre_round_imag = mac_res_imag + { {(DATA_WIDTH){1'b0}}, 
                                          mac_res_imag[MULT_WIDTH-DATA_WIDTH-1],
                                          {(MULT_WIDTH-DATA_WIDTH-1){!mac_res_imag[MULT_WIDTH-DATA_WIDTH-1]}} };

always_ff @(posedge clk) begin : imag_part
  if (rst) begin
    mul_res_imag <= '0;
    adder_imag_0   <= '0;
  end
  else begin
    // -- Stage 1 - Multiplication --
    mul_res_imag <= signal_imag * i_coef_real;
    adder_imag_0 <= i_adder_complex[DATA_WIDTH-1:0];

    // -- Stage 2 - Addition --
    mac_res_imag <= mul_res_imag + { adder_imag_0, {(DATA_WIDTH-1){1'b0}} };

    // -- Stage 3 - Rounding -- 
    round_res_imag <= pre_round_imag[MULT_WIDTH-1:MULT_WIDTH-DATA_WIDTH-1];

  end
end : imag_part

assign o_res_complex = { round_res_real, round_res_imag };

endmodule