

class ahb_driver extends uvm_driver #(ahb_transaction);

 
  virtual ahb_if vif;

  `uvm_component_utils(ahb_driver)

  
  function new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set for driver")
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    ahb_transaction tr;

    `uvm_info(get_type_name(), "Driver started...", UVM_LOW)
    reset_signals();

    forever begin
      seq_item_port.get_next_item(tr);

      `uvm_info(get_type_name(),
        $sformatf("Driving Transaction :: %s", tr.convert2string()), UVM_MEDIUM)

      drive_transaction(tr);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_transaction(ahb_transaction tr);
    @(posedge vif.clk);

   
    vif.hsel   <= 1'b1;
    vif.hwrite <= tr.hwrite;
    vif.hsize  <= tr.hsize;
    vif.hburst <= tr.hburst;
    vif.hprot  <= tr.hprot;
    vif.hready <= 1'b1;

    vif.haddr  <= tr.haddr;
    vif.hwdata <= tr.hwdata;

    
    @(posedge vif.clk);
    vif.hready <= 1'b0;

   
    @(posedge vif.clk);
    wait (vif.hready_out == 1'b1);

    
    tr.hresp      = vif.hresp;
    tr.hrdata     = vif.hrdata;
    tr.hready_out = vif.hready_out;

    `uvm_info(get_type_name(),
      $sformatf("Response: hready_out=%0b hresp=0x%0h hrdata=0x%08h",
        tr.hready_out, tr.hresp, tr.hrdata), UVM_LOW)

    
    reset_signals();
  endtask

  
  virtual task reset_signals();
    vif.hsel    <= 0;
    vif.hwrite  <= 0;
    vif.haddr   <= 0;
    vif.hwdata  <= 0;
    vif.hburst  <= 3'b000;
    vif.hprot   <= 4'b0000;
    vif.hsize   <= 3'b010;
    vif.hready  <= 1'b1;
  endtask

endclass : ahb_driver
