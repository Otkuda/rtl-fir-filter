import fir_addrmap_pkg::*;

module fir_axil_slave_adapter #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
) (

  input logic     i_clk,
  input logic     i_rst,

  // AXI-Lite interface

  axi4lite_intf.slave s_axil,
  // Hardware interface
  input  logic [DATA_WIDTH - 1:0] i_csr,

  output logic [             0:0] o_we_strb, 
  output logic [DATA_WIDTH - 1:0] o_mem_addr,
  output logic [DATA_WIDTH - 1:0] o_mem_data,
  output logic [DATA_WIDTH - 1:0] o_filter_depth
);


fir_addrmap__in_t hwif_in;
fir_addrmap__out_t hwif_out;

always_comb begin
    o_filter_depth = hwif_out.FIR.filter_depth.VALUE.value; 
    o_mem_addr = hwif_out.FIR.mem_addr.ADDR.value; 
    o_mem_data = hwif_out.FIR.mem_data.DATA.value; 
    o_we_strb = hwif_out.FIR.we_strb.STRB.value; 

    hwif_in.FIR.CSR.CODE.next = i_csr[15:0];
end

fir_addrmap addrmap_inst (
    .clk        ( i_clk ),
    .rst        ( i_rst ),

    .s_axil     ( s_axil ),
    
    .hwif_in    ( hwif_in  ),
    .hwif_out   ( hwif_out )
);

endmodule

