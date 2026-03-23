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

logic signed [DATA_WIDTH+8-1:0] res [0:1];

genvar i;
generate
  for (i = 0; i < 2; i++) begin
    compute_mac # (
      .DATA_WIDTH(DATA_WIDTH)
    ) mac_inst (
      .clk(clk),
      .rst(rst),
      .i_signal(i_signal_complex[DATA_WIDTH*(i+1)-1:DATA_WIDTH*(1-i)]),
      .i_coef(i_coef_real),
      .i_res_valid(i_res_valid),
      .o_res(res[i])
    );
  end
endgenerate

always_comb begin : real_clip
  if (res[1] > 24'sd32767)
    o_res_complex[DATA_WIDTH*2-1:DATA_WIDTH] = 16'sd32767;
  else if (res[1] < -24'sd32768)
    o_res_complex[DATA_WIDTH*2-1:DATA_WIDTH] = -16'sd32768;
  else
    o_res_complex[DATA_WIDTH*2-1:DATA_WIDTH] = 16'(res[1]);
end : real_clip

always_comb begin : imag_clip
  if (res[0] > 24'sd32767)
    o_res_complex[DATA_WIDTH-1:0] = 16'sd32767;
  else if (res[0] < -24'sd32768)
    o_res_complex[DATA_WIDTH-1:0] = -16'sd32768;
  else
    o_res_complex[DATA_WIDTH-1:0] = 16'(res[0]);
end : imag_clip

endmodule