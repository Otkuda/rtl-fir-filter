`timescale 1ns/1ps
module compute_mac_tb;

localparam CLK_PERIOD = 10;
localparam DATA_WIDTH = 16;

logic clk, rst;

logic                  i_res_vld;
logic signed [DATA_WIDTH-1:0] i_signal;
logic signed [DATA_WIDTH-1:0] i_coef;
logic signed [DATA_WIDTH-1:0] o_res;

compute_mac DUT (
  .clk        (clk),
  .rst        (rst),
  .i_signal   (i_signal),
  .i_coef     (i_coef),
  .i_res_valid(i_res_vld),
  .o_res      (o_res)
);

initial begin
  clk = '0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

task reset();
  rst <= '1;
  repeat(2) @(posedge clk);
  rst <= '0;
endtask

initial begin
  i_res_vld <= '0;
  i_signal  <= '0;
  i_coef    <= '0;
  reset();
  repeat(3) @(posedge clk);

  repeat(5) begin
    i_res_vld <= '0;
    i_signal <= -2;
    i_coef   <= 16'b0100000000000000;
    @(posedge clk);
    i_signal <= 8;
    i_coef   <= 16'b0010000000000000;
    @(posedge clk);
    i_signal <= '0;
    i_coef   <= '0;
    @(posedge clk);
    @(posedge clk);
    i_res_vld <= '1;
    @(posedge clk);
  end

  $stop;
end

endmodule