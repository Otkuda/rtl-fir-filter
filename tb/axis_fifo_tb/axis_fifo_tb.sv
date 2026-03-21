`timescale 1ns/1ps

module axis_fifo_tb();

localparam CLK_PERIOD = 10;
localparam FIFO_DEPTH = 16;
localparam WIDTH = 8;

logic clk, rst;
logic [WIDTH-1:0] axis_tdata_s, axis_tdata_m;
logic             axis_tvalid_s, axis_tvalid_m;
logic             axis_tready_s, axis_tready_m;

axis_fifo #(
  .DEPTH(FIFO_DEPTH),
  .WIDTH(WIDTH)
) DUT (
  .clk(clk),
  .rst(rst),

  .axis_tdata_s(axis_tdata_s),
  .axis_tvalid_s(axis_tvalid_s),
  .axis_tready_s(axis_tready_s), 

  .axis_tdata_m(axis_tdata_m),
  .axis_tvalid_m(axis_tvalid_m),
  .axis_tready_m(axis_tready_m)
);

logic [WIDTH-1:0] golden_q[$];

initial begin
  clk = 0;
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;   
  end
end

task reset();
  @(posedge clk);
  rst <= '1;
  repeat(2) @(posedge clk);
  rst <= '0;
endtask

task automatic push_data(
  input logic [WIDTH-1:0] data
);
  axis_tvalid_s <= '1;
  axis_tdata_s  <= data;
  @(posedge clk);
  wait(axis_tready_s);
  axis_tvalid_s <= '0;
  axis_tdata_s  <= '0;
  $display("[%t] Pushed data %d\n", $time, data);

  golden_q.push_back(data);
  if (golden_q.size() > 16) begin
    $error("Invalid queue size\n");
  end
endtask

task static pop_data();
  logic [WIDTH-1:0] data;
  axis_tready_m <= '1;
  @(posedge clk);
  wait(axis_tvalid_m);
  axis_tready_m <= '0;
  data = axis_tdata_m;
  $display("[%t] Popped data %d\n", $time, data);

  golden_q.pop_front();
endtask

task automatic test_full();

  fork
    repeat (FIFO_DEPTH * 2) push_data($random());
  join_none

  repeat (FIFO_DEPTH + 3) @(posedge clk);
  pop_data();
  #(CLK_PERIOD * 3);
  repeat(FIFO_DEPTH * 2 - 3) pop_data();
endtask

initial begin
  $monitor("[%t] Queue state: %p\n\n", $time, golden_q);

  axis_tready_m = '0;
  reset();
  test_full();
  $stop;
end

endmodule
