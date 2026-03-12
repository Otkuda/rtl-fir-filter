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

/*
 * Методы
 */

task reset()
  rst <= '1;
  #(CLK_PERIOD);
  rst <= '0;
endtask

task drive_inputs()
  coef_real   <= $urandom_range(-2 ** 15, 2 ** 15);
  signal_real <= $urandom_range(-2 ** 15, 2 ** 15);
  signal_imag <= $urandom_range(-2 ** 15, 2 ** 15);

endtask

task test()
  wait(~rst);
  repeat(100) begin
    drive_inputs();
    mon_outputs();
    check();
  end
endtask

initial begin
  clk = '0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

initial begin
  reset();
  test();
  $stop;
end


endmodule