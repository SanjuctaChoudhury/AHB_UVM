class passive_agent extends uvm_agent;
  
  `uvm_component_utils(passive_agent)
  output_monitor h_outmon;
  
  function new(string name="passive_agent",uvm_component parent);
    super.new(name,parent);
		`uvm_info("PASSIVE_AGENT",$sformatf("--- PASSIVE_AGENT IS BUILT ---"),UVM_NONE);				
		
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    h_outmon=output_monitor::type_id::create("h_outmon",this);
  endfunction
  
endclass