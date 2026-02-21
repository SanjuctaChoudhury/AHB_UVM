class test extends uvm_test;
  
  `uvm_component_utils(test)
  
  environment h_environment;
  SEQUENCE h_sequence;
    
  function new(string name="test",uvm_component parent);
    super.new(name,parent); 
		`uvm_info("TEST",$sformatf("--- TEST IS BUILT ---"),UVM_NONE);						
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    h_environment=environment::type_id::create("h_environment",this);
    h_sequence=SEQUENCE::type_id::create("h_sequence",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    print();
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this,"objection_raised");
    h_sequence.start(h_environment.h_active.h_seqr);
    #60;
    phase.drop_objection(this,"objection_dropped");
  endtask
    
  
  
  
endclass
