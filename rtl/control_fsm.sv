`timescale 1ns/1ps
module control_fsm #(
  DEPTH = 128
) (
  input logic clk,
  input logic rst,

  input  logic [$clog2(DEPTH)-1:0] i_c_depth,

  // Delay line control
  input  logic i_fifo_valid,
  output logic o_dl_ena,
  output logic [$clog2(DEPTH)-1:0] o_dl_addr, 

  // Coefficient memory read address
  output logic [$clog2(DEPTH)-1:0] o_cmem_addr,

  // MAC result valid
  input  logic i_res_fifo_ready,
  output logic o_res_valid,
  output logic o_mac_clr
);

localparam MAC_LATENCY = 3;

typedef enum logic [0:0] { 
  IDLE = '0,
  GET_RESULT = 1'b1
} state_t;

state_t state, next_state;
logic [$clog2(DEPTH):0] cnt;

always_ff @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  case (state)
    IDLE: begin
      if (i_fifo_valid && i_res_fifo_ready)
        next_state = GET_RESULT;
    end
    GET_RESULT: begin
      if (o_res_valid && i_res_fifo_ready) 
        next_state = IDLE;
    end
    default: next_state = IDLE;
  endcase
end

always_ff @(posedge clk) begin
  if (state == GET_RESULT && cnt < i_c_depth + MAC_LATENCY - 1) begin
    cnt <= cnt + 1'b1;
  end
  else begin
    cnt <= '0;
  end
end

assign o_dl_ena    = (state == IDLE) && i_fifo_valid && i_res_fifo_ready;
assign o_res_valid = (state == GET_RESULT) && (cnt == i_c_depth + MAC_LATENCY - 1);
assign o_mac_clr   = (state == GET_RESULT) && (cnt == '0);

assign o_dl_addr   = (state == GET_RESULT && cnt < i_c_depth) ? cnt[$clog2(DEPTH)-1:0] : '0;
assign o_cmem_addr = (state == GET_RESULT && cnt < i_c_depth) ? cnt[$clog2(DEPTH)-1:0] : '0;

endmodule