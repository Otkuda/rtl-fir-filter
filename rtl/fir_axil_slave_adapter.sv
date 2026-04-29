import fir_addrmap_pkg::*;

module fir_axil_slave_adapter #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
) (

  input logic     i_clk,
  input logic     i_rst,

  // AXI-Lite interface

  input  logic                    i_awvalid,
  input  logic [ADDR_WIDTH - 1:0] i_awaddr,
  input  logic [2:0]              i_awprot,
  output logic                    o_awready,

  input  logic                    i_wvalid,
  input  logic [DATA_WIDTH - 1:0] i_wdata,
  input  logic [DATA_WIDTH/8-1:0] i_wstrb,
  output logic                    o_wready,

  input  logic                    i_bready,
  output logic                    o_bvalid,
  output logic [1:0]              o_bresp,

  input  logic                    i_arvalid,
  input  logic [ADDR_WIDTH - 1:0] i_araddr,
  input  logic [2:0]              i_arprot,
  output logic                    o_arready,

  input  logic                    i_rready,
  output logic [DATA_WIDTH - 1:0] o_rdata,
  output logic [1:0]              o_rresp,
  output logic                    o_rvalid,

  // Hardware interface
  input  logic [DATA_WIDTH - 1:0] i_csr,

  output logic [             0:0] o_we_strb, 
  output logic [DATA_WIDTH - 1:0] o_mem_addr,
  output logic [DATA_WIDTH - 1:0] o_mem_data,
  output logic [DATA_WIDTH - 1:0] o_filter_depth
);

axi4lite_intf #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH )
) axi4lite_if ();

always_comb begin
    axi4lite_if.AWVALID = i_awvalid;
    axi4lite_if.AWADDR  = i_awaddr;
    axi4lite_if.AWPROT  = i_awprot;
    o_awready = axi4lite_if.AWREADY;

    axi4lite_if.WVALID  = i_wvalid;
    axi4lite_if.WDATA   = i_wdata;
    axi4lite_if.WSTRB   = i_wstrb;
    o_wready  = axi4lite_if.WREADY;

    axi4lite_if.BREADY  = i_bready;
    o_bvalid  = axi4lite_if.BVALID;
    o_bresp   = axi4lite_if.BRESP ;

    axi4lite_if.ARVALID = i_arvalid;
    axi4lite_if.ARADDR  = i_araddr;
    axi4lite_if.ARPROT  = i_arprot;
    o_arready = axi4lite_if.ARREADY;

    axi4lite_if.RREADY  = i_rready;
    o_rdata   =  axi4lite_if.RDATA;
    o_rresp   =  axi4lite_if.RRESP;
    o_rvalid  = axi4lite_if.RVALID;
end

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

    .s_axil     ( axi4lite_if ),
    
    .hwif_in    ( hwif_in  ),
    .hwif_out   ( hwif_out )
);

endmodule

