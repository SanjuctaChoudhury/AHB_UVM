
class ahb_base_sequence extends uvm_sequence #(ahb_transaction);
  `uvm_object_utils(ahb_base_sequence)

  function new(string name = "ahb_base_sequence");
    super.new(name);
  endfunction

  
  virtual task body();
    ahb_transaction tr;
    int i;

    `uvm_info(get_type_name(), "Starting AHB base sequence...", UVM_LOW)

   
    tr = ahb_transaction::type_id::create("single_write");
    start_item(tr);
      tr.randomize() with {
        haddr  == 8'h10;
        hwrite == 1;
        hburst == 3'b000;
        hwdata == 32'hDEADBEEF;
      };
    finish_item(tr);
    `uvm_info(get_type_name(), $sformatf("SINGLE WRITE: %s", tr.convert2string()), UVM_LOW)
    #10ns;

    
    tr = ahb_transaction::type_id::create("single_read");
    start_item(tr);
      tr.randomize() with {
        haddr  == 8'h10;
        hwrite == 0;
        hburst == 3'b000;
      };
    finish_item(tr);
    `uvm_info(get_type_name(), $sformatf("SINGLE READ: %s", tr.convert2string()), UVM_LOW)
    #20ns;

    
    `uvm_info(get_type_name(), "Starting Incremental Burst WRITE (4-beat)...", UVM_LOW)
    for (i = 0; i < 4; i++) begin
      tr = ahb_transaction::type_id::create($sformatf("burst_write_%0d", i));
      start_item(tr);
        tr.randomize() with {
          haddr  == (8'h20 + i*4);
          hwrite == 1;
          hburst == 3'b001;  // INCR burst
          hwdata == (32'hBEEF0000 + i);
        };
      finish_item(tr);
      #10ns;
    end

    
    `uvm_info(get_type_name(), "Starting Incremental Burst READ (4-beat)...", UVM_LOW)
    for (i = 0; i < 4; i++) begin
      tr = ahb_transaction::type_id::create($sformatf("burst_read_%0d", i));
      start_item(tr);
        tr.randomize() with {
          haddr  == (8'h20 + i*4);
          hwrite == 0;
          hburst == 3'b001;
        };
      finish_item(tr);
      #10ns;
    end

    `uvm_info(get_type_name(), "Starting WRAP4 Burst WRITE...", UVM_LOW)
    for (i = 0; i < 4; i++) begin
      tr = ahb_transaction::type_id::create($sformatf("wrap4_write_%0d", i));
      start_item(tr);
        tr.randomize() with {
          haddr  == ((8'h30 + i*4) & 8'h3C);  
          hwrite == 1;
          hburst == 3'b010;                   
          hwdata == (32'hFACE0000 + i);
        };
      finish_item(tr);
      #10ns;
    end

    
    `uvm_info(get_type_name(), "Starting WRAP4 Burst READ...", UVM_LOW)
    for (i = 0; i < 4; i++) begin
      tr = ahb_transaction::type_id::create($sformatf("wrap4_read_%0d", i));
      start_item(tr);
        tr.randomize() with {
          haddr  == ((8'h30 + i*4) & 8'h3C);
          hwrite == 0;
          hburst == 3'b010;
        };
      finish_item(tr);
      #10ns;
    end

    `uvm_info(get_type_name(), "Completed AHB base sequence successfully.", UVM_LOW)
  endtask

endclass : ahb_base_sequence
