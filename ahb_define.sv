
`define AMBA_AHB_VER_3 

// AHB bus parameters
`define AW 32            
`define DW 32            
`ifdef AMBA_AHB_VER_3
`define RW 1             
`elsif AMBA_AHB_VER_2
`define RW 2             
`endif
  `define DE "BIG"         


`define H_READ       1'b0
`define H_WRITE      1'b1


`define H_IDLE       2'b00   
`define H_BUSY       2'b01  
`define H_NONSEQ     2'b10   
`define H_SEQ        2'b11   

// HSIZE[2:0]  Transfer Size
`define H_SIZE_8     3'b000
`define H_SIZE_16    3'b001
`define H_SIZE_32    3'b010
`define H_SIZE_64    3'b011
`define H_SIZE_128   3'b100
`define H_SIZE_256   3'b101
`define H_SIZE_512   3'b110
`define H_SIZE_1024  3'b111

// HBURST[2:0] Burst Type
`define H_SINGLE     3'b000  
`define H_INCR       3'b001  
`define H_WRAP4      3'b010  
`define H_INCR4      3'b011  
`define H_WRAP8      3'b100  
`define H_INCR8      3'b101  
`define H_WRAP16     3'b110  
`define H_INCR16     3'b111 

// HRESP       Transfer Response
`ifdef AMBA_AHB_VER_3
`define H_OKAY    1'b0       
`define H_ERROR   1'b1       
`elsif AMBA_AHB_VER_2
`define H_OKAY    2'b00
`define H_ERROR   2'b01
`endif
`define H_RETRY   2'b10      
`define H_SPLIT   2'b11      


