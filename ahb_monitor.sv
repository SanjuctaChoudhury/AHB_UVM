

class ahb_monitor extends uvm_monitor;

  
  virtual ahb_if vif;

  
  uvm_analysis_port #(ahb_transaction) mon_ap;

  `uvm_component_utils(ahb_monitor)

  
  function new(string name = "ahb_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Virtual interface not set for monitor")
  endfunction

 
  virtual task run_phase(uvm_phase phase);
    ahb_transaction tr;

    `uvm_info(get_type_name(), "Monitor started...", UVM_LOW)

    forever begin
      @(posedge vif.clk);

     
      if (vif.hsel && vif.hready) begin
        tr = ahb_transaction::type_id::create("tr_mon", this);

        tr.haddr   = vif.haddr;
        tr.hwrite  = vif.hwrite;
        tr.hburst  = vif.hburst;
        tr.hsize   = vif.hsize;
        tr.hprot   = vif.hprot;
        tr.hsel    = vif.hsel;
        tr.hready  = vif.hready;

        if (vif.hwrite) begin
          
          tr.hwdata = vif.hwdata;

          
          @(posedge vif.clk);
          wait (vif.hready_out == 1'b1);

          tr.hresp      = vif.hresp;
          tr.hready_out = vif.hready_out;

          `uvm_info(get_type_name(),
            $sformatf("WRITE captured: Addr=0x%0h Data=0x%0h HRESP=0x%0h",
              tr.haddr, tr.hwdata, tr.hresp),
            UVM_MEDIUM)
        end
        else begin
          
          @(posedge vif.clk);
          wait (vif.hready_out == 1'b1);

          tr.hrdata     = vif.hrdata;
          tr.hresp      = vif.hresp;
          tr.hready_out = vif.hready_out;

          `uvm_info(get_type_name(),
            $sformatf("READ captured: Addr=0x%0h Data=0x%0h HRESP=0x%0h",
              tr.haddr, tr.hrdata, tr.hresp),
            UVM_MEDIUM)
        end

       
        mon_ap.write(tr);
      end
    end
  endtask

endclass : ahb_monitor
