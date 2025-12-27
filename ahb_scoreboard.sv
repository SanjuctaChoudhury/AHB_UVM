class ahb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(ahb_scoreboard)

  uvm_analysis_imp#(ahb_transaction, ahb_scoreboard) sb_ap;

  
  ahb_transaction pkt_qu[$];       
  bit [31:0] sc_mem [0:255];       
  int total_transactions = 0;
  int processed_transactions = 0;


  function new (string name = "ahb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    sb_ap = new("sb_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach (sc_mem[i])
      sc_mem[i] = 32'h0;
  endfunction

  
  virtual function void write(ahb_transaction tr);
    pkt_qu.push_back(tr);
    total_transactions++;
  endfunction


  virtual task run_phase(uvm_phase phase);
    ahb_transaction ahb_pkt;
    phase.raise_objection(this);

    forever begin
     
      wait(pkt_qu.size() > 0);
      ahb_pkt = pkt_qu.pop_front();
      processed_transactions++;

      if (ahb_pkt.hwrite) begin
        if (ahb_pkt.haddr < 256) begin
          sc_mem[ahb_pkt.haddr] = ahb_pkt.hwdata;
          `uvm_info(get_type_name(),
            $sformatf("WRITE: Addr=0x%0h Data=0x%0h (Burst=%0b)",
                      ahb_pkt.haddr, ahb_pkt.hwdata, ahb_pkt.hburst),
            UVM_MEDIUM)
        end else begin
          `uvm_error(get_type_name(),
            $sformatf("WRITE ERROR: Addr=0x%0h out of range!", ahb_pkt.haddr))
        end
      end

      else begin
        if (ahb_pkt.haddr < 256) begin
          if ($isunknown(ahb_pkt.hrdata)) begin
            `uvm_error(get_type_name(),
              $sformatf("READ ERROR: Addr=0x%0h Returned X/Z Data=0x%0h",
                        ahb_pkt.haddr, ahb_pkt.hrdata))
          end else if (sc_mem[ahb_pkt.haddr] === ahb_pkt.hrdata) begin
            `uvm_info(get_type_name(),
              $sformatf("READ MATCH: Addr=0x%0h Data=0x%0h (Burst=%0b)",
                        ahb_pkt.haddr, ahb_pkt.hrdata, ahb_pkt.hburst),
              UVM_LOW)
          end else begin
            `uvm_error(get_type_name(),
              $sformatf("READ MISMATCH: Addr=0x%0h Expected=0x%0h Actual=0x%0h",
                        ahb_pkt.haddr, sc_mem[ahb_pkt.haddr], ahb_pkt.hrdata))
          end
        end else begin
          `uvm_error(get_type_name(),
            $sformatf("READ ERROR: Addr=0x%0h out of range!", ahb_pkt.haddr))
        end
      end

      
      if (processed_transactions == 23) begin
        `uvm_info(get_type_name(),
          "All transactions processed â ending simulation.",
          UVM_MEDIUM)
        phase.drop_objection(this);
        return;
      end
    end
  endtask

endclass