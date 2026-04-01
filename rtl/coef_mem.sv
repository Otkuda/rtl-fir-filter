`timescale 1ns/1ps

module coef_mem #(
  DATA_WIDTH = 16,
  DEPTH = 128
) (
  input logic clk,
  input logic rst,

  input  logic wren,
  input  logic [$clog2(DEPTH)-1:0] w_addr,
  input  logic [$clog2(DEPTH)-1:0] r_addr,
  input  logic [   DATA_WIDTH-1:0] w_data,
  output logic [   DATA_WIDTH-1:0] r_data
);

logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

always_ff @(posedge clk) begin
  if (rst) begin
    for (int i = 0; i < DEPTH; i++)
      mem[i] <= '0;
  end
  else begin
    if (wren) begin
      mem[w_addr] <= w_data;
    end
  end
end

assign r_data = mem[r_addr];

endmodule