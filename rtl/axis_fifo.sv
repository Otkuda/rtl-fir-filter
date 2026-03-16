module #(
  DEPTH = 8,
  WIDTH = 16
) axis_fifo (
  input logic clk,
  input logic rst,
  
  input  logic axis_tdata_s,
  input  logic axis_tvalid_s,
  output logic axis_tready_s,

  output logic axis_tdata_m,
  output logic axis_tvalid_m,
  input  logic axis_tready_m
);

  localparam pointer_width = $clog2 (depth),
             counter_width = $clog2 (depth + 1);

  localparam [counter_width - 1:0] max_ptr = counter_width' (depth - 1);


  logic [pointer_width - 1:0] wr_ptr_d, rd_ptr_d, wr_ptr_q, rd_ptr_q;
  logic empty_d, full_d, empty_q, full_q;
  logic [width - 1:0] data [0: depth - 1];
  logic push, pop;

  assign push = axis_tvalid_s && !full_q;
  assign pop = axis_tready_m && !empty_q;


  always_comb begin

    if (push)
      wr_ptr_d = wr_ptr_q == max_ptr ? '0 : wr_ptr_q + 1'b1;
    else
      wr_ptr_d = wr_ptr_q;

    if (pop)
      rd_ptr_d = rd_ptr_q == max_ptr ? '0 : rd_ptr_q + 1'b1;
    else
      rd_ptr_d = rd_ptr_q;


    case ({ push, pop })
      2'b10: begin
        empty_d = 1'b0;
        full_d  = wr_ptr_d == rd_ptr_q;
      end
      2'b01: begin
        full_d = 1'b0;
        empty_d = rd_ptr_d == wr_ptr_q;
      end
      default: begin
        empty_d  = empty_q;
        full_d   = full_q;
      end
    endcase
  end


  always_ff @ (posedge clk or posedge rst)
    if (rst) begin
      wr_ptr_q <= '0;
      rd_ptr_q <= '0;
      empty_q  <= 1'b1;
      full_q   <= 1'b0;
    end
    else begin
      wr_ptr_q <= wr_ptr_d;
      rd_ptr_q <= rd_ptr_d;
      empty_q  <= empty_d;
      full_q   <= full_d;
    end


  always_ff @ (posedge clk)
    if (push)
      data [wr_ptr_q] <= axis_tdata_s;

  assign axis_tdata_m = data [rd_ptr_q];

  assign axis_tready_s = !full_q;
  assign axis_tvalid_m = !empty_q;

endmodule