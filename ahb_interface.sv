interface inter(input bit clk);
  
  logic [31:0]HADDR,HWDATA,HRDATA;
  logic [2:0]HBURST,HSIZE;
  logic [1:0]HTRANS;
  logic HSELx,HWRITE,HMASTLOCK;
	logic [3:0]HPROT;
  
  logic HRESETn;
  logic HRESP,HREADY;
  
 
  
  clocking cb_driver@(posedge clk);
    input HRESP,HREADY,HRDATA;
    output HADDR,HWDATA,HBURST,HSIZE,HTRANS,HSELx,HWRITE,HMASTLOCK,HRESETn;
  endclocking
  
  
   clocking cb_monitor@(posedge clk);
    input HRESP,HREADY,HRDATA;
    input HADDR,HWDATA,HBURST,HSIZE,HTRANS,HSELx,HWRITE,HMASTLOCK,HRESETn;
  endclocking 
  
  
endinterface
