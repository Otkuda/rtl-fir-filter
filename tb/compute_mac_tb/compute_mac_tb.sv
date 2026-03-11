`timescale 1ns/1ps

module compute_mac_tb();

localparam CLK_PERIOD = 10;

localparam DATA_WIDTH = 16;
localparam MULT_WIDTH = DATA_WIDTH * 2;

logic clk, rst;

logic signed [DATA_WIDTH-1:0] coef_real;
logic signed [DATA_WIDTH-1:0] signal_real, signal_imag;
logic signed [DATA_WIDTH-1:0] adder_real, adder_imag;
logic signed [DATA_WIDTH-1:0] res_real, res_imag;

compute_mac #(
  .DATA_WIDTH(DATA_WIDTH)
) DUT (
  .clk(clk),
  .rst(rst),

  .i_signal_complex({signal_real, signal_imag}),
  .i_coef_real(coef_real),
  .i_adder_complex({adder_real, adder_imag}),
  .o_res_complex({res_real, res_imag})
);

initial begin
  clk = '0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

initial begin
  @(posedge clk);
  rst <= '1;
  @(posedge clk);
  rst <= '0;
  signal_real <= -2;
  signal_imag <=  1;
  coef_real   <= 16'b1000000000000000;
  adder_real  <= '0;
  adder_imag  <= '0;
  @(posedge clk);
  signal_real <= 100;
  signal_imag <= 500;
  coef_real   <= 16'b1100000000000000;
  adder_real  <= -100;
  adder_imag  <= 1234;
  repeat (5) @(posedge clk);
  $stop;
end


endmodule