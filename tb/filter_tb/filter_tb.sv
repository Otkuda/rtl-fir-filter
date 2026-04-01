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

filter_sim #(
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

task reset();
  rst <= '1;
  repeat(2) @(posedge clk);
  rst <= '0;
endtask

task test_impulse_response();
  s_axis_dl_tvalid <= '1;
  m_axis_mac_tready <= '1;
  repeat(10) begin
    s_axis_dl_tdata <= '0;
    @(posedge clk);
    @(posedge s_axis_dl_tready);
  end
  s_axis_dl_tdata <= {16'd10000, 16'd0};
  @(posedge clk);
  @(posedge s_axis_dl_tready);
  repeat(10) begin
    s_axis_dl_tdata <= '0;
    @(posedge clk);
    @(posedge s_axis_dl_tready);
  end
  s_axis_dl_tvalid <= '0;
  m_axis_mac_tready <= '0;
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