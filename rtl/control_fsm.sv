`timescale 1ns/1ps
module control_fsm #(
  parameter DEPTH = 128,
  parameter OPT_DSP_ENA = 1,
  parameter SYNC_MEM_ENA = 1
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

localparam MAC_LATENCY = 5 + OPT_DSP_ENA;

typedef enum logic [0:0] { 
  IDLE = '0,
  GET_RESULT = 1'b1
} state_t;

state_t state, next_state;
logic [$clog2(DEPTH):0] cnt, cnt_max;
logic cmp_res;

always_ff @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
  end
  else begin
    state <= next_state;
  end
end

always_comb begin
  next_state = state;
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
  if (rst) begin
    cnt_max <= '0;
    cmp_res <= '0;
  end
  else begin
    if (state == IDLE) begin
      cnt_max <= i_c_depth + MAC_LATENCY - 1;
    end
    cmp_res <= cnt != cnt_max;
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    cnt <= '0;
  end
  else begin
    if (state == GET_RESULT && cmp_res) begin
      cnt <= cnt + 1'b1;
    end
    else begin
      cnt <= '0;
    end
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    o_dl_ena    <= '0; 
    o_res_valid <= '0;
    o_mac_clr   <= '0;
    o_dl_addr   <= '0;
    o_cmem_addr <= '0;
  end
  else begin
    o_dl_ena    <= (state == IDLE) && i_fifo_valid && i_res_fifo_ready;
    o_res_valid <= (state == GET_RESULT) && (cnt == cnt_max);
    o_mac_clr   <= (state == GET_RESULT) && (cnt == 1'b1);
    o_dl_addr   <=  cnt[$clog2(DEPTH)-1:0];
    o_cmem_addr <=  cnt[$clog2(DEPTH)-1:0];
  end
end

endmodule