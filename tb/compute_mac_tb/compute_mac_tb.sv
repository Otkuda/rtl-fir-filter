`timescale 1ns/1ps
module compute_mac_tb;

localparam CLK_PERIOD = 10;
localparam DATA_WIDTH = 16;

logic clk, rst;

logic                         i_mac_clr;
logic signed [DATA_WIDTH-1:0] i_signal;
logic signed [DATA_WIDTH-1:0] i_coef;
logic signed [33-1:0]         o_res;

opt_compute_mac DUT (
  .clk        (clk),
  .rst        (rst),
  .i_signal   (i_signal),
  .i_coef     (i_coef),
  .i_mac_clr  (i_mac_clr),
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
  i_mac_clr <= '0;
  i_signal  <= '0;
  i_coef    <= '0;
  reset();
  repeat(3) @(posedge clk);
  repeat (20) begin
    i_mac_clr <= '1;
    i_signal <= -3;
    i_coef   <= 16'b0100000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= 5;
    i_coef   <= 16'b0110000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= 2;
    i_coef   <= 16'b0100000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= -123;
    i_coef   <= 16'b1100000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= -3;
    i_coef   <= 16'b0100000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= 5;
    i_coef   <= 16'b0110000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= 2;
    i_coef   <= 16'b0100000000000000;
    @(posedge clk);
    i_mac_clr <= '0;
    i_signal <= -123;
    i_coef   <= 16'b1100000000000000;
    @(posedge clk);
  end
  i_mac_clr <= '0;
  i_signal <= '0;
  i_coef   <= 16'b0000000000000000;
  repeat (20) @(posedge clk);

  $stop;
end

endmodule