
//`include "ahb_define.v"

module amba_ahb_slave #(
 
  parameter AW = `AW,    
  parameter DW = `DW,    
  parameter DE = `DE,    
  parameter RW = `RW,    
 
  parameter MS = 1024,  
  parameter AM = {10{1'b1}},  
  parameter LW_NS = 0,  
  parameter LW_S  = 0,  
  parameter LR_NS = 0,  
  parameter LR_S  = 0  
)(
  
  input  wire          hclk,     
  input  wire          hresetn,  
 
  input  wire          hsel,    
  
  input  wire [AW-1:0] haddr,    
  input  wire    [1:0] htrans,   
  input  wire          hwrite,   
  input  wire    [2:0] hsize,    
  input  wire    [2:0] hburst,   
  input  wire    [3:0] hprot,    
  input  wire [DW-1:0] hwdata,   
 
  output wire [DW-1:0] hrdata,   
  output reg           hready,   
  output reg  [RW-1:0] hresp,    

  input  wor           error     
);



localparam SW = DW/8; 


wor           error_req;

assign error_req = 1'b0;
assign error_req = error;         


wire [32-1:0] delay;    
wire [32-1:0] cnt_t;   
reg  [32-1:0] cnt_t_r;  


reg           hsel_r;
reg  [AW-1:0] haddr_r;
reg     [1:0] htrans_r;
reg           hwrite_r;
reg     [2:0] hsize_r;
reg     [2:0] hburst_r;
reg     [2:0] hprot_r;

reg     [7:0] mem [0:MS-1];

genvar i;

wire    [7:0] bytes;
wire [DW-1:0] wdata;    
wire [DW-1:0] rdata;   
wire          trn;      
wire          trn_req;  
wire          trn_ack;  



always @(negedge hresetn, posedge hclk)
if (~hresetn) begin
  htrans_r <= `H_IDLE;
  for(int i=0;i<1024;i++) mem[i]=i;
end else if (hready) begin
  hsel_r   <= hsel;
  haddr_r  <= haddr;
  htrans_r <= htrans;
  hwrite_r <= hwrite;
  hsize_r  <= hsize;
  hburst_r <= hburst;
  hprot_r  <= hprot;
end



always @(negedge hresetn, posedge hclk)
if (~hresetn) begin
  cnt_t_r <= 0;
  hready  <= 1'b1;
  hresp   <= `H_OKAY;
end else begin
 
  cnt_t_r <= cnt_t;
 
  if (error) begin
    if (hready) begin
      if ((htrans == `H_IDLE) | (htrans == `H_BUSY)) begin
        hresp   <= `H_OKAY;
        hready  <= 1'b1;
      end
      if ((htrans == `H_NONSEQ) | (htrans == `H_SEQ)) begin
        hresp   <= (cnt_t == 0) ? `H_ERROR : `H_OKAY;
        hready  <= 1'b0;
      end
    end else begin
      if ((htrans_r == `H_NONSEQ) | (htrans_r == `H_SEQ)) begin
        if (hresp == `H_OKAY) begin
          hresp   <= (cnt_t == 0) ? `H_ERROR : `H_OKAY;
        end else begin
          hready  <= 1'b1;
        end
      end
    end
 
  end else begin
    hresp   <= `H_OKAY;
    hready  <= (cnt_t == 0);
  end
end

assign delay = htrans[0] ? (hwrite ? LW_S  : LR_S )
                         : (hwrite ? LW_NS : LR_NS);

assign cnt_t = hready ? (htrans[1] & hsel ? delay
                                          : 0)
                      : cnt_t_r - 1;



assign trn_req = ((htrans_r == `H_NONSEQ) | (htrans_r == `H_SEQ)) & hsel_r;
assign trn_ack = hready;
assign trn     = trn_req & trn_ack;

assign bytes = 1 << hsize_r;


generate
  for (i=0; i<SW; i=i+1) begin
    if (DE == "BIG") begin
//      assign  wdata [DW-1-8*i-:8] = hwdata [8*i+:8];
//      assign hrdata [DW-1-8*i-:8] =  rdata [8*i+:8];
    end else if (DE == "LITTLE") begin

    end
  end
        assign  wdata  =  hwdata ;
        assign  hrdata =  rdata ;
endgenerate


generate
  for (i=0; i<SW; i=i+1) begin
    always @(posedge hclk) begin
      if (trn & (hresp == `H_OKAY) & hwrite_r) begin
        if (((haddr_r&AM)%SW <= i) & (i < ((haddr_r&AM)%SW + bytes)))  mem [(haddr_r&AM)/SW*SW+i] <= wdata [8*i+:8];
      end
    end
  end
endgenerate


generate
  for (i=0; i<SW; i=i+1) begin
    assign rdata [8*i+:8] = ((trn & (hresp == `H_OKAY) & ~hwrite_r) & ((haddr_r&AM)%SW <= i) & (i < ((haddr_r&AM)%SW + bytes))) ? mem [(haddr_r&AM)/SW*SW+i] : 8'hxx;
  end
endgenerate

endmodule
