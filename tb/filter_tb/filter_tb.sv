`timescale 1ns/1ps
module filter_tb;

localparam CLK_PERIOD = 10;
localparam DATA_WIDTH = 16;
localparam DEPTH      = 128;

logic clk, rst;

logic [DATA_WIDTH*2-1:0] s_axis_dl_tdata;
logic s_axis_dl_tvalid, s_axis_dl_tready;

logic wren;
logic [DATA_WIDTH-1:0] w_coef_data;
logic [$clog2(DEPTH)-1:0] w_coef_addr;

logic [$clog2(DEPTH)-1:0] filter_depth;

logic [DATA_WIDTH*2-1:0] m_axis_mac_tdata;
logic m_axis_mac_tready, m_axis_mac_tvalid;
logic [DATA_WIDTH*2-1:0] golden_res_q [$];

seq_filter_top #(
  .DATA_WIDTH(DATA_WIDTH),
  .DEPTH(DEPTH)
) DUT (
  .*
);

initial begin
  clk = '0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

task automatic load_coefs(
  input string path 
);
  logic signed [15:0] load_val;
  int file = $fopen(path, "r");
  int i = 0;
  $display("Loading coefs from \"%s\"\n", path);

  if(file == 0) begin
    $fatal("Can't open file\n");
  end
  while (!$feof(file)) begin
    $fscanf(file, "%d\n", load_val);
    wren <= 1'b1;
    w_coef_addr <= i; 
    w_coef_data <= load_val;
    i++;
    @(posedge clk);
  end
  wren <= '0;
  w_coef_addr <= '0;
  @(posedge clk);
endtask

task automatic load_golden_ir (
  input string path
);
  logic [15:0] load_val;
  int file = $fopen(path, "r");
  int i = 0;
  $display("Loading coefs from \"%s\"\n", path);

  if(file == 0) begin
    $fatal("Can't open file\n");
  end
  while (!$feof(file)) begin
    $fscanf(file, "%d\n", load_val);
    golden_res_q.push_back({load_val, 16'b0});
  end
endtask

task reset();
  rst <= '1;
  repeat(2) @(posedge clk);
  rst <= '0;
endtask


task gen_impulse();
  s_axis_dl_tdata <= {16'd32767, 16'd0};
  @(posedge clk);
  @(posedge s_axis_dl_tready);
  s_axis_dl_tdata <= '0;
endtask

task wait_work_cycles(int n_cycles);
  repeat(n_cycles) begin
    @(posedge clk);
    @(posedge s_axis_dl_tready);
  end
endtask

task test_impulse_response();
  s_axis_dl_tvalid <= '1;
  m_axis_mac_tready <= '1;
  s_axis_dl_tdata <= '0;
  load_golden_ir("./ref_data/golden_IR.txt");
  wait_work_cycles(10);
  fork
    monitor_result();
  join_none
  gen_impulse();
  wait_work_cycles(10);
  s_axis_dl_tvalid <= '0;
  m_axis_mac_tready <= '0;
endtask

task monitor_result();
  logic [DATA_WIDTH*2-1:0] actual_res;
  logic [DATA_WIDTH*2-1:0] expected_res;
  forever begin
    @(posedge m_axis_mac_tvalid);
    expected_res = golden_res_q.pop_front();
    actual_res = m_axis_mac_tdata;
    if (actual_res != expected_res)
      $error("%t Wrong result actual: %h , expected: %h\n", $time, actual_res, expected_res);
  end
endtask

initial begin
  reset();
  s_axis_dl_tdata <= '0;
  s_axis_dl_tvalid <= '0;
  filter_depth <= 8;
  m_axis_mac_tready <= '0;
  load_coefs("./ref_data/lowpass8_coefs.txt");
  test_impulse_response();

  repeat(5) @(posedge clk);
  $stop;
end

endmodule