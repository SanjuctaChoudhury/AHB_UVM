class sequence_item extends uvm_sequence_item;
  
  `uvm_object_utils(sequence_item)
  
  rand bit [31:0]HADDR,HWDATA;
	rand bit [3:0]HPROT;
  rand bit [2:0]HBURST,HSIZE;
  rand bit [1:0]HTRANS;
  rand bit HSELx,HWRITE,HMASTLOCK;
  rand bit HRESETn;
  

	bit HRESP,HREADY;
	bit [31:0]HRDATA;
	//constraint c1{}
  
  function new(string name="sequence_item");
    super.new(name);
  endfunction

endclass