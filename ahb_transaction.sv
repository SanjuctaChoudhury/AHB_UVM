
`ifndef AHB_TRANSACTION_SV
`define AHB_TRANSACTION_SV

class ahb_transaction extends uvm_sequence_item;

  
  rand bit [7:0]   haddr;
  rand bit         hwrite;
  rand bit [2:0]   hsize;
  rand bit [2:0]   hburst;
  rand bit [3:0]   hprot;
  rand bit [31:0]  hwdata;
       bit [31:0]  hrdata;
  rand bit         hsel;
  rand bit         hready;
       bit         hready_out;
       bit [1:0]   hresp;

 
  `uvm_object_utils_begin(ahb_transaction)
    `uvm_field_int(haddr,       UVM_ALL_ON)
    `uvm_field_int(hwrite,      UVM_ALL_ON)
    `uvm_field_int(hsize,       UVM_ALL_ON)
    `uvm_field_int(hburst,      UVM_ALL_ON)
    `uvm_field_int(hprot,       UVM_ALL_ON)
    `uvm_field_int(hwdata,      UVM_ALL_ON)
    `uvm_field_int(hrdata,      UVM_ALL_ON | UVM_NOPRINT)
    `uvm_field_int(hsel,        UVM_ALL_ON)
    `uvm_field_int(hready,      UVM_ALL_ON)
    `uvm_field_int(hready_out,  UVM_ALL_ON | UVM_NOPRINT)
    `uvm_field_int(hresp,       UVM_ALL_ON | UVM_NOPRINT)
  `uvm_object_utils_end

  
  function new(string name = "ahb_transaction");
    super.new(name);
  endfunction

  
  constraint c_valid_addr {
    haddr inside {[0:255]};         
  }

  constraint c_burst_type {
    hburst inside {3'b000, 3'b001, 3'b010}; 
  }

  constraint c_hsize {
    hsize inside {3'b010}; 
  }

  constraint c_protocol_defaults {
    hsel   == 1'b1;
    hready == 1'b1;
  }

 
  virtual function string convert2string();
    return $sformatf(
      "AHB_TXN :: haddr=0x%02h | hwrite=%0b | hsize=%0d | hburst=%0d | hprot=0x%0h | hwdata=0x%08h | hrdata=0x%08h | hsel=%0b | hready=%0b | hready_out=%0b | hresp=0x%0h",
      haddr, hwrite, hsize, hburst, hprot, hwdata, hrdata, hsel, hready, hready_out, hresp
    );
  endfunction

 
  virtual function void do_copy(uvm_object rhs);
    ahb_transaction rhs_;
    if (!$cast(rhs_, rhs)) return;
    super.do_copy(rhs);
    this.haddr       = rhs_.haddr;
    this.hwrite      = rhs_.hwrite;
    this.hsize       = rhs_.hsize;
    this.hburst      = rhs_.hburst;
    this.hprot       = rhs_.hprot;
    this.hwdata      = rhs_.hwdata;
    this.hrdata      = rhs_.hrdata;
    this.hsel        = rhs_.hsel;
    this.hready      = rhs_.hready;
    this.hready_out  = rhs_.hready_out;
    this.hresp       = rhs_.hresp;
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    ahb_transaction rhs_;
    if (!$cast(rhs_, rhs)) return 0;
    return ((haddr == rhs_.haddr) &&
            (hwrite == rhs_.hwrite) &&
            (hwdata == rhs_.hwdata) &&
            (hrdata == rhs_.hrdata));
  endfunction

endclass : ahb_transaction

`endif 
