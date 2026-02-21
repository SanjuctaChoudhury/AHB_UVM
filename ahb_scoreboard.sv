class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  `uvm_analysis_imp_decl(_outmon)
  
  uvm_analysis_imp #(sequence_item,scoreboard) h_input_imp;
  uvm_analysis_imp_outmon #(sequence_item,scoreboard) h_output_imp;
  
  sequence_item h_seqinp,h_seqout;

	uvm_event ev;
  
  
  function new(string name="scoreboard",uvm_component parent);
    super.new(name,parent);
			`uvm_info("SCOREBOARD",$sformatf(" --- SCOREBOARD IS CREATED ---\n"),UVM_FULL);		
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    h_seqinp=sequence_item::type_id::create("h_seqinp",this);
    h_seqout=sequence_item::type_id::create("h_seqout",this);
    h_input_imp=new("h_input_imp",this);
    h_output_imp=new("h_output_imp",this);
  endfunction
  
  function void write(sequence_item INDATA);
    h_seqinp=INDATA;
  endfunction
  
  function void write_outmon(sequence_item OUTDATA);
    h_seqout=OUTDATA;
  endfunction 


	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		ev=uvm_event_pool::get_global("myevent");
		
		forever begin
			`uvm_info("SCOREBOARD",$sformatf(" ----------------- IN SCOREBOARD ------------------------------------\n"),UVM_FULL);  
			ev.wait_trigger;
			if(h_seqinp.HREADY==h_seqout.HREADY && h_seqinp.HRESP==h_seqout.HRESP && h_seqinp.HRDATA==h_seqout.HRDATA)begin
				`uvm_info("pass_inp",$sformatf("HRESETn %d HSELx %D HADDR %d HWRITE %D HWDATA %h HBURST %D HSIZE %D HTRANS %d HRDATA %h HRESP %D HREADY %D",h_seqinp.HRESETn,h_seqinp.HSELx,h_seqinp.HADDR,h_seqinp.HWRITE,h_seqinp.HWDATA,h_seqinp.HBURST,h_seqinp.HSIZE,h_seqinp.HTRANS,h_seqinp.HRDATA,h_seqinp.HRESP,h_seqinp.HREADY),UVM_HIGH);
				`uvm_info("pass_out",$sformatf("HRESETn %d HSELx %D HADDR %d HWRITE %D HWDATA %h HBURST %D HSIZE %D HTRANS %d HRDATA %h HRESP %D HREADY %D",h_seqout.HRESETn,h_seqout.HSELx,h_seqout.HADDR,h_seqout.HWRITE,h_seqout.HWDATA,h_seqout.HBURST,h_seqout.HSIZE,h_seqout.HTRANS,h_seqout.HRDATA,h_seqout.HRESP,h_seqout.HREADY),UVM_HIGH);
			end
			else begin
						`uvm_info("fail_inp",$sformatf("HRESETn %d HSELx %D HADDR %d HWRITE %D HWDATA %h HBURST %D HSIZE %D HTRANS %d HRDATA %h HRESP %D HREADY %D",h_seqinp.HRESETn,h_seqinp.HSELx,h_seqinp.HADDR,h_seqinp.HWRITE,h_seqinp.HWDATA,h_seqinp.HBURST,h_seqinp.HSIZE,h_seqinp.HTRANS,h_seqinp.HRDATA,h_seqinp.HRESP,h_seqinp.HREADY),UVM_HIGH);
				`uvm_info("fail_out",$sformatf("HRESETn %d HSELx %D HADDR %d HWRITE %D HWDATA %h HBURST %D HSIZE %D HTRANS %d HRDATA %h HRESP %D HREADY %D",h_seqout.HRESETn,h_seqout.HSELx,h_seqout.HADDR,h_seqout.HWRITE,h_seqout.HWDATA,h_seqout.HBURST,h_seqout.HSIZE,h_seqout.HTRANS,h_seqout.HRDATA,h_seqout.HRESP,h_seqout.HREADY),UVM_HIGH);


			end
		end
	endtask
  
endclass
