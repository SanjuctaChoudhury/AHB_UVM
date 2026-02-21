class environment extends uvm_env;
  
  `uvm_component_utils(environment)
  
  
  active_agent h_active;
  passive_agent h_passive;
	scoreboard h_scrb;  
  
  function new(string name="environment",uvm_component parent);
    super.new(name,parent);
		`uvm_info("ENVIRONMENT",$sformatf("--- ENVIRONMENT IS BUILT ---"),UVM_NONE);				
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    h_active=active_agent::type_id::create("h_active",this);
    h_passive=passive_agent::type_id::create("h_passive",this);
		h_scrb=scoreboard::type_id::create("h_scrb",this);
  endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		h_active.h_inpmon.h_input_port.connect(h_scrb.h_input_imp);
		h_passive.h_outmon.h_outputport.connect(h_scrb.h_output_imp);
	endfunction
  
  
endclass
