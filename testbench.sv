

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ahb_interface.sv"
`include "ahb_transaction.sv"
`include "ahb_sequencer.sv"
`include "ahb_sequence.sv"
`include "ahb_driver.sv"
`include "ahb_monitor.sv"
`include "ahb_scoreboard.sv"
`include "ahb_subscriber.sv"
`include "ahb_env.sv"
`include "ahb_test.sv"


module tb_ahb_slave;

 
  logic clk;
  logic reset_n;

  
  ahb_if ahb_bus(clk, reset_n);

  
  ahb_slave dut (
      .clk        (ahb_bus.clk),
      .haddr      (ahb_bus.haddr),
      .hwrite     (ahb_bus.hwrite),
      .hsize      (ahb_bus.hsize),
      .hburst     (ahb_bus.hburst),
      .hprot      (ahb_bus.hprot),
      .hwdata     (ahb_bus.hwdata),
      .hrdata     (ahb_bus.hrdata),
      .hsel       (ahb_bus.hsel),
     .hready     (ahb_bus.hready),
      .hready_out (ahb_bus.hready_out),
      .hresp      (ahb_bus.hresp)
  );

  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  
  end

 
  initial begin
    reset_n = 0;
    #25;
    reset_n = 1;
    `uvm_info("TB", "Reset Deasserted", UVM_LOW)
  end

  
  initial begin
    
    uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top", "vif", ahb_bus);

    
    run_test("ahb_test");
  end

  
  initial begin
    #2000;
    `uvm_info("TB", "Simulation finished after 2000ns", UVM_LOW)
    $finish;
  end

endmodule : tb_ahb_slave
