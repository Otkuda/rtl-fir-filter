module mem_ring_buffer #(
  DATA_WIDTH = 16,
  DEPTH = 128
) (
  input clk,
  input rst,

  input  logic [DATA_WIDTH-1:0] s_axis_tdata,
  input  logic                  s_axis_tvalid,
  output logic                  s_axis_tready,

  input  logic ena,
  input  logic [$clog2(DEPTH)-1:0] r_addr,
  output logic [   DATA_WIDTH-1:0] out_data
);

(* ram_style = "block" *)
logic [DATA_WIDTH-1:0] mem [0:DEPTH];
logic [DATA_WIDTH-1:0] i_data_reg, o_data_reg;

logic [$clog2(DEPTH)-1:0] w_ptr;
logic [$clog2(DEPTH)-1:0] r_addr_reg;

assign s_axis_tready = ena;

logic push, push_reg;
assign push = s_axis_tvalid & s_axis_tready;
  
initial begin
  for (int i = 0; i < DEPTH; i++) begin
    mem[i] = 0;
  end
end

// write pointer increment
always_ff @(posedge clk) begin
  if (rst) begin
    w_ptr <= '0;
  end
  else begin
    if (push_reg) begin
      if (w_ptr != DEPTH-1)
        w_ptr <= w_ptr + 1'b1;
      else
        w_ptr <= '0;
    end
  end
end

always_ff @(posedge clk) begin
  if (rst) begin
    i_data_reg <= '0;
    push_reg   <= '0;
    r_addr_reg <= '0;
  end
  else begin
    push_reg   <= push;
    i_data_reg <= s_axis_tdata;
    r_addr_reg <= r_addr;
  end
end

// write data
always_ff @(posedge clk) begin
  if (push_reg) begin
    mem[w_ptr] <= i_data_reg;
  end
end

logic [$clog2(DEPTH)-1:0] r_ptr;

// read pointer calculation
// Addr 0 = w_ptr - 1
// Addr 1 = w_ptr - (1 + r_addr)
// ..
// Loop around if negative read pointer
always_ff @(posedge clk) begin
  if (rst) begin
    r_ptr <= '0;
  end
  else begin
    if (w_ptr > r_addr_reg) begin
      r_ptr <= w_ptr - 1'b1 - r_addr_reg;
    end
    else begin
      r_ptr <= DEPTH + (w_ptr - 1'b1 - r_addr_reg);
    end
  end
end
  
// Syncronous read
always_ff @(posedge clk) begin
  o_data_reg <= mem[r_ptr];
  out_data   <= o_data_reg;
end


endmodule