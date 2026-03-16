module #(
  WIDTH = 8,
  DEPTH = 8
) signal_ring_buffer (
    input                      clk,
    input                      rst,

    input                      in_valid,
    input        [WIDTH - 1:0] in_data,

    output logic               out_valid,
    output logic [WIDTH - 1:0] out_data
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [WIDTH-1:0] vld_mem;
    logic [$clog2(DEPTH)-1:0] mem_ptr;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            mem_ptr <= '0;
            for (int i = 0; i < DEPTH; i++) begin 
                mem[i] <= '0;
                vld_mem[i] <= '0;
            end
        end
        else begin
            mem[mem_ptr]     <= in_data;
            vld_mem[mem_ptr] <= in_valid;
            
            out_valid <= vld_mem[mem_ptr];
            out_data  <= mem[mem_ptr];

            if (mem_ptr < DEPTH-1)
                mem_ptr <= mem_ptr + 1'b1;
            else 
                mem_ptr <= '0;
        end
    end

    always_comb begin
        out_valid = vld_mem[mem_ptr];
        out_data  = mem[mem_ptr];
    end

endmodule
