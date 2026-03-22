`timescale 1ns/1ps

import util::*;

module compute_mac_tb();

localparam CLK_PERIOD = 10;

localparam DATA_WIDTH = 16;
localparam MULT_WIDTH = DATA_WIDTH * 2;
localparam FP_PRECISION = DATA_WIDTH - 1;

logic clk, rst;

logic signed [DATA_WIDTH-1:0] coef_real;
logic [DATA_WIDTH*2-1:0] signal_complex;
logic [DATA_WIDTH*2-1:0] adder_complex;
logic [DATA_WIDTH*2-1:0] res_complex;

logic [DATA_WIDTH*2-1:0] expected_result_q[$];

compute_mac #(
  .DATA_WIDTH(DATA_WIDTH)
) DUT (
  .clk(clk),
  .rst(rst),

  .i_signal_complex(signal_complex),
  .i_coef_real(coef_real),
  .i_adder_complex(adder_complex),
  .o_res_complex(res_complex)
);

/*
 * Методы
 */

task automatic reset();
  rst <= '1;
  #(CLK_PERIOD);
  rst <= '0;
endtask

function automatic calc_expected(
  input logic [DATA_WIDTH*2-1:0] signal,
  input logic [DATA_WIDTH*2-1:0] adder,
  input logic [DATA_WIDTH-1:0]   coef
);

  int sig_r = $signed(signal[DATA_WIDTH*2-1:DATA_WIDTH]);
  int sig_i = $signed(signal[DATA_WIDTH-1:0]);
  int add_r = $signed(adder[DATA_WIDTH*2-1:DATA_WIDTH]);
  int add_i = $signed(adder[DATA_WIDTH-1:0]);
  int coef_r = $signed(coef);

  real res_r = sig_r * ($itor(coef_r) / $itor(2 ** FP_PRECISION)) + add_r;
  real res_i = sig_i * ($itor(coef_r) / $itor(2 ** FP_PRECISION)) + add_i;

  bit [DATA_WIDTH*2-1:0] result;

  result = { roundToInt16(res_r), roundToInt16(res_i) };

  expected_result_q.push_back(result);
  $display("[%t] Pushed new expected %f+(%f). Queue: %p\n", $time(), res_r, res_i, expected_result_q);

endfunction

task automatic drive_inputs(
  input logic signed [DATA_WIDTH-1:0] signal_real,
  input logic signed [DATA_WIDTH-1:0] adder_real,  
  input logic signed [DATA_WIDTH-1:0] signal_imag,
  input logic signed [DATA_WIDTH-1:0] adder_imag,  
  input logic signed [DATA_WIDTH-1:0] l_coef_real
);
  @(posedge clk);
  coef_real      <= l_coef_real;
  signal_complex <= { signal_real, signal_imag };
  adder_complex  <= { adder_real, adder_imag };
  $display("[%t] New inputs: sig = (%d)+(%d)j, coef = %d, adder = (%d) + (%d)\n", $time(),
                            signal_real, signal_imag, l_coef_real, adder_real, adder_imag);

  calc_expected({ signal_real, signal_imag }, { adder_real, adder_imag }, l_coef_real);
  
endtask

task automatic mon_outputs();

  logic [DATA_WIDTH*2-1:0] actual;
  logic [DATA_WIDTH*2-1:0] expected;
  wait(expected_result_q.size() > 0);
  repeat(3) @(posedge clk);

  forever begin
    if(expected_result_q.size() > 0) begin
      expected = expected_result_q.pop_front();
      $display("[%t] Popped value from queue: %d\n", $time(), expected);
      #1;
      actual = res_complex;
      if (expected !== res_complex) begin
        $display("[%t] Mismatch: Expected %d+(%dj), Actual %d+(%d)j\n", $time(),
                  expected[DATA_WIDTH*2-1:DATA_WIDTH], expected[DATA_WIDTH-1:0],
                  actual[DATA_WIDTH*2-1:DATA_WIDTH], actual[DATA_WIDTH-1:0]);
      end
      else begin
        $display("[%t] Match\n", $time());
      end
    end
    @(posedge clk);
  end

endtask

task test();
  reset();
  fork
    mon_outputs();
  join_none
  repeat(10) begin
    logic signed [DATA_WIDTH-1:0] sr, si;
    logic signed [DATA_WIDTH-1:0] ar, ai;
    logic signed [DATA_WIDTH-1:0] c;
    sr = $urandom_range(0, 20000);
    si = $urandom_range(0, 20000);
    ar = $urandom_range(0, 20000);
    ai = $urandom_range(0, 20000);
    c  = $urandom_range(0, 2 ** 16);
    drive_inputs(sr-10000, si-10000, ar-10000, ai-10000, c - 2 ** 15);
  end
  repeat(5) @(posedge clk);
endtask

initial begin
  clk = '0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

initial begin
  rst = '0;
  signal_complex = '0;
  adder_complex  = '0;
  coef_real = '0;

  reset();
  test();

  $stop;
end


endmodule