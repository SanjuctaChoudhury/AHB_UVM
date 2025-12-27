

class ahb_env extends uvm_env;

 
  ahb_driver       drv;
  ahb_monitor      mon;
  ahb_scoreboard   sb;
  ahb_sequencer    seqr;
  ahb_subscriber   sub;

 
  virtual ahb_if   vif;

  `uvm_component_utils(ahb_env)

 
  function new(string name = "ahb_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info(get_type_name(), "Building AHB environment...", UVM_LOW)

    
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("AHB_ENV", "Virtual interface not set for AHB_ENV")
    end

   
    drv  = ahb_driver     ::type_id::create("drv", this);
    mon  = ahb_monitor    ::type_id::create("mon", this);
    sb   = ahb_scoreboard ::type_id::create("sb", this);
    seqr = ahb_sequencer  ::type_id::create("seqr", this);
    sub  = ahb_subscriber ::type_id::create("sub", this);

   
    uvm_config_db#(virtual ahb_if)::set(this, "drv", "vif", vif);
    uvm_config_db#(virtual ahb_if)::set(this, "mon", "vif", vif);
  endfunction

  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    
    drv.seq_item_port.connect(seqr.seq_item_export);

   
    mon.mon_ap.connect(sb.sb_ap);
    mon.mon_ap.connect(sub.analysis_export);

    `uvm_info(get_type_name(), "Connections established successfully.", UVM_LOW)
  endfunction

 
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(),
      $sformatf("Environment setup complete:\n Driver=%s\n Monitor=%s\n Scoreboard=%s\n Subscriber=%s\n Sequencer=%s",
      drv.get_full_name(), mon.get_full_name(), sb.get_full_name(), sub.get_full_name(), seqr.get_full_name()),
      UVM_LOW)
  endfunction

endclass : ahb_env
