class sequencer extends uvm_sequencer  #(sequence_item);
  
  `uvm_component_utils(sequencer)
  
  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
		`uvm_info("SEQUENCER",$sformatf("--- SEQUENCER IS BUILT ---"),UVM_NONE);		
  endfunction
  
  
endclass