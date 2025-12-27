

class ahb_test extends uvm_test;

 
  ahb_env          env;
  ahb_base_sequence seq;
  virtual ahb_if   vif;

  `uvm_component_utils(ahb_test)

 
  function new(string name = "ahb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    
    env = ahb_env::type_id::create("env", this);

   
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal("AHB_TEST", "Virtual interface not set in config DB");

   
    uvm_config_db#(virtual ahb_if)::set(this, "env", "vif", vif);
  endfunction

 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("AHB_TEST", "Starting AHB Base Sequence...", UVM_LOW);

    
    wait (vif.reset_n === 1'b1);
    repeat (5) @(posedge vif.clk);

    
    seq = ahb_base_sequence::type_id::create("seq");
    seq.start(env.seqr);

    
    #200;
    `uvm_info("AHB_TEST", "AHB Sequence completed successfully.", UVM_LOW);

   
    #50;

    
    if (env.sub != null) begin
      `uvm_info("AHB_TEST",
        $sformatf("Functional Coverage: %0.2f%%",
        env.sub.cover_bus.get_inst_coverage()), UVM_NONE);
    end

    phase.drop_objection(this);
  endtask

endclass : ahb_test
