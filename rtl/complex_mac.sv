module complex_mac #(
  DATA_WIDTH = 16
) (
  input logic clk,
  input logic rst,

  input logic signed [DATA_WIDTH*2-1:0] i_signal_complex,
  input logic signed [DATA_WIDTH-1  :0] i_coef_real,

  input  logic i_res_valid,
  output logic signed [DATA_WIDTH*2-1:0] o_res_complex  
);

genvar i;
generate
  for (i = 0; i < 2; i++) begin
    compute_mac # (
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),
      .i_signal(i_signal_complex[DATA_WIDTH*(i+1)-1:]),
      .i_coef(i_coef_real),
      .i_res_valid(),
      .o_res()
    );
  end
endgenerate

endmodule