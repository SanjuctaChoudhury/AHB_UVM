class output_monitor extends uvm_monitor;
  
  `uvm_component_utils(output_monitor)
  
  virtual inter intf;
  sequence_item h_seqitem;
  uvm_analysis_port #(sequence_item)h_outputport;
  
  function new(string name="output_monitor",uvm_component parent);
    super.new(name,parent);
		`uvm_info("OUTPUT_MONITOR",$sformatf("--- OUTPUT_MONITOR IS BUILT ---"),UVM_NONE);		
		
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    h_seqitem=sequence_item::type_id::create("h_seqitem");
    h_outputport=new("h_outputport",this);
    uvm_config_db #(virtual inter)::get(this,this.get_full_name,"inter",intf);
		
  endfunction
  task run_phase(uvm_phase phase);
				super.run_phase(phase);
			forever@(intf.cb_monitor)begin
					h_seqitem.HADDR=intf.HADDR;
					h_seqitem.HWDATA=intf.HWDATA;
					h_seqitem.HRDATA=intf.HRDATA;
					h_seqitem.HTRANS=intf.HTRANS;
					h_seqitem.HPROT=intf.HPROT;
					h_seqitem.HBURST=intf.HBURST;
					h_seqitem.HREADY=intf.HREADY;
					h_seqitem.HRESP=intf.HRESP;
					h_seqitem.HRESETn=intf.HRESETn;
					h_seqitem.HMASTLOCK=intf.HMASTLOCK;
					h_seqitem.HWRITE=intf.HWRITE;
					h_seqitem.HSELx=intf.HSELx;
					h_seqitem.HSIZE=intf.HSIZE;

				h_outputport.write(h_seqitem);
				

			end
	endtask
endclass
