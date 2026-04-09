`timescale 1ns/1ps
module axis_fifo #(
  DEPTH = 8,
  WIDTH = 16
) (
  input logic clk,
  input logic rst,
  
  input  logic [WIDTH-1:0] s_axis_tdata,
  input  logic             s_axis_tvalid,
  output logic             s_axis_tready,

  output logic [WIDTH-1:0] m_axis_tdata,
  output logic             m_axis_tvalid,
  input  logic             m_axis_tready
);

  localparam pointer_width = $clog2 (DEPTH),
             counter_width = $clog2 (DEPTH + 1);

  localparam [counter_width - 1:0] max_ptr = counter_width' (DEPTH - 1);


  logic [pointer_width - 1:0] wr_ptr_d, rd_ptr_d, wr_ptr_q, rd_ptr_q;
  logic empty_d, full_d, empty_q, full_q;
  (* ram_style = "block" *) logic [WIDTH - 1:0] data [0: DEPTH - 1];
  logic push, pop;

  assign push = s_axis_tvalid && !full_q;
  assign pop = m_axis_tready && !empty_q;


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


  always_ff @ (posedge clk)
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
      data [wr_ptr_q] <= s_axis_tdata;

  assign m_axis_tdata = data [rd_ptr_q];

  assign s_axis_tready = !full_q;
  assign m_axis_tvalid = !empty_q;

endmodule