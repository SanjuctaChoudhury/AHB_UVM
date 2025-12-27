

class ahb_subscriber extends uvm_subscriber #(ahb_transaction);
  virtual ahb_if vif;

 
  bit [7:0]   addr;
  bit [31:0]  data;
  bit [2:0]   burst_type;
  bit         write_en;
  bit [1:0]   hresp;

  
  covergroup cover_bus;
    
    coverpoint burst_type {
      bins SINGLE = {3'b000};
      bins INCR4  = {3'b001};
      bins WRAP4  = {3'b010};
      illegal_bins RESERVED = {[3'b011:3'b111]};
    }

    
    coverpoint write_en {
      bins READ  = {1'b0};
      bins WRITE = {1'b1};
    }

    

    
    coverpoint addr {
      bins LOW_ADDR  = {[8'h00 : 8'h3F]};
      bins MID_ADDR  = {[8'h40 : 8'h7F]};
      bins HIGH_ADDR = {[8'h80 : 8'hFF]};
    }


  endgroup

  
  `uvm_component_utils(ahb_subscriber)
   

  
  function new(string name = "ahb_subscriber", uvm_component parent = null);
    super.new(name, parent);
    //if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif)) begin
    //`uvm_fatal("NO_VIF", "Virtual interface must be set for AHB Subscriber.")
  //end
    cover_bus = new();
  endfunction

  
  virtual function void write(ahb_transaction t);
   
    burst_type = t.hburst;
    addr       = t.haddr;
    data       = t.hwrite ? t.hwdata : t.hrdata;
    write_en   = t.hwrite;
    hresp      = t.hresp;

    `uvm_info("AHB_SUBSCRIBER",
      $sformatf("Coverage Sampling: Addr=0x%0h, Burst=%0b, Write=%0b, Resp=%0b",
      addr, burst_type, write_en, hresp),
      UVM_LOW)

    cover_bus.sample();
  endfunction

endclass : ahb_subscriber
