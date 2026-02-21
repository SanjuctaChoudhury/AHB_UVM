class driver extends uvm_driver #(sequence_item);
  
  `uvm_component_utils(driver)
  
  virtual inter intf;
  
  
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
		`uvm_info("DRIVER",$sformatf("--- DRIVER IS BUILT ---"),UVM_NONE);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db #(virtual inter)::get(this,this.get_full_name,"inter",intf));
  endfunction
  
  task run_phase(uvm_phase phase);
  
    
    forever@(intf.cb_driver)begin
      seq_item_port.get_next_item(req);
      intf.HADDR<=req.HADDR;
      intf.HWDATA=req.HWDATA;
      intf.HPROT=req.HPROT;
      intf.HBURST=req.HBURST;
      intf.HSIZE=req.HSIZE;
      intf.HTRANS=req.HTRANS;
      intf.HSELx=req.HSELx;
      intf.HWRITE=req.HWRITE;
      intf.HMASTLOCK=req.HMASTLOCK;
      intf.HRESETn=req.HRESETn;
      seq_item_port.item_done();
    end
    
  endtask
  
  
endclass


