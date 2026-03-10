`timescale 1ns/1ps

module compute_mac #(
  DATA_WIDTH = 16
) (
  input  clk,
  input  rst,

  input  logic signed [DATA_WIDTH-1:0] i_signal_real,
  input  logic signed [DATA_WIDTH-1:0] i_signal_imag,
  input  logic signed [DATA_WIDTH-1:0] i_coef_real,
  input  logic signed [DATA_WIDTH-1:0] i_coef_imag,

  output logic signed [DATA_WIDTH-1:0] o_res_real,
  output logic signed [DATA_WIDTH-1:0] o_res_imag
);

logic [31:0] cnt;

always_ff @( posedge clk ) begin
  if (rst) begin
    cnt <= '0;
  end
  else begin
    cnt <= cnt + 1'b1;
  end
end
  
endmodule