`timescale 1ns/1ps

module sync_coef_mem #(
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

(* ram_style = "block" *) logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

always_ff @(posedge clk) begin
    if (wren) begin
      mem[w_addr] <= w_data;
    end
    else begin
      r_data <= mem[r_addr];
    end
end


endmodule