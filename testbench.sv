
`include "ahb_interface.sv"
`include "package.sv"
module ahb_top;
  
  import uvm_pkg::*;
  import my_package::*;
  
  bit clk;
  
  inter intf(clk);
  
  
  always #5 clk++;
  
  amba_ahb_slave#(

  `AW,    
  `DW,    
  `DE,    
 `RW,    
  
  1024,  
  {10{1'b1}},  
 
   0,  
   0,  
   0,  
   0   
  ) duv(
    .hclk(clk),     
    .hresetn(intf.HRESETn),  
    .hsel(intf.HSELx),     
    .haddr(intf.HADDR),   
    .htrans(intf.HTRANS),   
    .hwrite(intf.HWRITE),   
    .hsize(intf.HSIZE),    
    .hburst(intf.HBURST),   
    .hprot(intf.HPROT),    
    .hwdata(intf.HWDATA),  
    .hrdata(intf.HRDATA),   
    .hready(intf.HREADY),   
    .hresp(intf.HRESP),    
 
    .error(0)    
);
  initial begin
    uvm_config_db #(virtual inter)::set(null,"uvm_test_top.*","inter",intf);
    run_test("test");
  end
  
  
  
  
endmodule