`timescale 1ns/1ps
module delay_line #(
  DATA_WIDTH = 16,
  DEPTH = 128
) (
  input logic clk,
  input logic rst,

  input  logic [DATA_WIDTH-1:0] s_axis_tdata,
  input  logic                  s_axis_tvalid,
  output logic                  s_axis_tready,
  
  input  logic ena,
  input  logic [$clog2(DEPTH)-1:0] addr,
  output logic [   DATA_WIDTH-1:0] out_data
);

logic [DATA_WIDTH-1:0] delay_regs [0:DEPTH-1];

assign s_axis_tready = ena;

always_ff @(posedge clk) begin
  if (rst) begin
    for (int i = 0; i < DEPTH; i++) begin
      delay_regs[i] <= '0;
    end
  end
  else begin
    if (ena && s_axis_tvalid) begin
      delay_regs[0] <= s_axis_tdata;
      for (int i = 1; i < DEPTH; i++) begin
        delay_regs[i] <= delay_regs[i-1];
      end
    end
  end
end

assign out_data = delay_regs[addr];

endmodule