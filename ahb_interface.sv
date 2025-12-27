

interface ahb_if(input logic clk, input logic reset_n);

  
  logic [7:0]   haddr;       
  logic         hwrite;      
  logic [2:0]   hsize;       
  logic [2:0]   hburst;      
  logic [3:0]   hprot;       
  logic [31:0]  hwdata;    
  logic [31:0]  hrdata;     
  logic         hsel;        
  logic         hready;      
  logic         hready_out;  
  logic [1:0]   hresp;      

  
  modport master (
    output haddr, hwrite, hsize, hburst, hprot, hwdata, hsel, hready,
    input  hrdata, hready_out, hresp
  );

  
  modport slave (
    input  haddr, hwrite, hsize, hburst, hprot, hwdata, hsel, hready,
    output hrdata, hready_out, hresp
  );

  
  modport monitor (
    input haddr, hwrite, hsize, hburst, hprot, hwdata, hrdata,
          hsel, hready, hready_out, hresp
  );

  

  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns;
    output haddr, hwrite, hsize, hburst, hprot, hwdata, hsel, hready;
    input  hrdata, hready_out, hresp;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1ns;
    input haddr, hwrite, hsize, hburst, hprot, hwdata, hrdata,
          hsel, hready, hready_out, hresp;
  endclocking

endinterface : ahb_if
