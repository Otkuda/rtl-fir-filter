module compute_mac_tb();

localparam CLK_PERIOD = 10;

logic clk, rst;

compute_mac DUT (
  .clk(clk),
  .rst(rst),

  .signal_real(),
  .signal_imag(),
  .coef_real(),
  .coef_imag(),
  .res_real(),
  .res_imag()
);

initial begin
  forever begin
    #(CLK_PERIOD / 2) clk = ~clk;
  end
end

initial begin
  #(CLK_PERIOD * 10);
  $stop
end


endmodule