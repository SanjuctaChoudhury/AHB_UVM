class input_monitor extends uvm_monitor;
  
  `uvm_component_utils(input_monitor)
  
  virtual inter intf;
  
  
  uvm_analysis_port #(sequence_item)h_input_port;
  
  sequence_item h_seqitem;


	bit [7:0]memory[1024]; 
  
	bit [31:0]TEMP_ADDR;  

	bit [31:0]ADDRESS_QUE[$];	

	bit [1:0]st_counter;			

	bit error_count;					

	uvm_event eve;
  
  function new(string name="input_monitor",uvm_component parent);
    super.new(name,parent);
		`uvm_info("INPUT_MONITOR",$sformatf("--- INPUT_MONITOR IS BUILT ---"),UVM_NONE);		
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual inter)::get(this,this.get_full_name,"inter",intf);
    h_input_port=new("h_input_port",this);
    h_seqitem=sequence_item::type_id::create("h_seqitem",this);
  endfunction

	


	task run_phase(uvm_phase phase);
		
		eve=uvm_event_pool::get_global("myevent");

		forever@(intf.cb_monitor)begin
			h_seqitem.HRESETn=intf.HRESETn;
			h_seqitem.HADDR=intf.HADDR;
			h_seqitem.HWDATA=intf.HWDATA;
			h_seqitem.HPROT=intf.HPROT;
			h_seqitem.HBURST=intf.HBURST;
			h_seqitem.HSIZE=intf.HSIZE;
			h_seqitem.HTRANS=intf.HTRANS;
			h_seqitem.HSELx=intf.HSELx;
			h_seqitem.HWRITE=intf.HWRITE;
			h_seqitem.HREADY=intf.HREADY;
			h_seqitem.HMASTLOCK=intf.HMASTLOCK;			
			
			fork 
				self_check;
				resp;
			join
			h_input_port.write(h_seqitem);
			eve.trigger;
			
			`uvm_info("INP_MON",$sformatf(" ****** VALUES of HRESETn=%0d HADDR=%0d HWDATA=%0h HBURST=%0d HSIZE=%0d HTRANS=%0d HSELx=%0d HWRITE=%0d  HRDATA=%0h HRESP=%0d HREADY=%0d",h_seqitem.HRESETn, h_seqitem.HADDR,h_seqitem.HWDATA,h_seqitem.HBURST,h_seqitem.HSIZE, h_seqitem.HTRANS, h_seqitem.HSELx,h_seqitem.HWRITE,h_seqitem.HRDATA,h_seqitem.HRESP,h_seqitem.HREADY),UVM_NONE);

		end
	endtask
  


	task self_check;

		if(!h_seqitem.HRESETn)begin
			h_seqitem.HRESP=0;
			h_seqitem.HREADY=0;
			h_seqitem.HRDATA=0;
			st_counter=0;
			ADDRESS_QUE.delete();
		end

		else begin
			
			if(h_seqitem.HSELx && h_seqitem.HREADY)begin
				
				if(h_seqitem.HTRANS==2'd2 || h_seqitem.HBURST==3'd0)begin
					`uvm_info("INPUT_MONITOR",$sformatf("NEW TRANSACTION HAS STARTED"),UVM_HIGH);
					ADDRESS_QUE.push_back(h_seqitem.HADDR);
					
					if( st_counter == 'd1 )begin
						TEMP_ADDR=ADDRESS_QUE.pop_front();
						$display($time,"\t   -------------- SINGLE TRANSFER -------------------------");						
						write_read;
						st_counter=0;
						ADDRESS_QUE.delete();  
					end
					st_counter++;
				
				end

				else if(h_seqitem.HTRANS==2'd3)begin
					st_counter=0;
					TEMP_ADDR=ADDRESS_QUE.pop_front();
					
							

					write_read;

					ADDRESS_QUE.push_back(h_seqitem.HADDR); 
				
				end

				else if(h_seqitem.HTRANS==2'd1)begin
					
					if(h_seqitem.HBURST=='d1)begin
						`uvm_info("BUSY_STATE_END",$sformatf("MASTER HAS ENDED UNDEFINED LENGTH TRANSFER"),UVM_HIGH);
					end
					else begin
						`uvm_info("BUSY_STATE",$sformatf("MASTER HAS INSERTED DELAY IN BURST"),UVM_HIGH);
					end
									
				end

				else begin
						`uvm_info("IDLE_STATE",$sformatf("MASTER HAS INSERTED DELAY IN BURST"),UVM_HIGH);
						st_counter=0;
						ADDRESS_QUE.delete();  
				end
					

				
			end

			else begin 
			
				`uvm_info("WAIT_STATE",$sformatf("---- WAITING   HREADY=%0d  HSELx=%0d ----",h_seqitem.HREADY,h_seqitem.HSELx),UVM_NONE);
			
			end


		end


	endtask



	
	
	task write_read;
		
		if(h_seqitem.HWRITE)begin
			
			for(int i=0;i< 2**h_seqitem.HSIZE ;i++)begin
				memory[TEMP_ADDR+i]=h_seqitem.HWDATA[(i*8)+:8];
				$display($time,"i=%d  memory[%0d]=%h",i,TEMP_ADDR+i,memory[TEMP_ADDR+i]);
			end
			`uvm_info("WRITE_TRANSFER",$sformatf("VALUES OF  HRESP=%0d HREADY=%d",h_seqitem.HRESP,h_seqitem.HREADY),UVM_HIGH);

		end

		else begin
			
			for(int i=0;i< 2**h_seqitem.HSIZE ;i++)begin
				h_seqitem.HRDATA[(i*8)+:8]=memory[TEMP_ADDR+i];
				$display($time,"i=%d  memory[%0d]=%h",i,TEMP_ADDR+i,memory[TEMP_ADDR+i]);
			end
			`uvm_info("READ_TRANSFER",$sformatf("VALUES OF HRDATA=%0h  HRESP=%0d HREADY=%d",h_seqitem.HRDATA,h_seqitem.HRESP,h_seqitem.HREADY),UVM_HIGH);
		end
			
	endtask


	task resp;
		if(!h_seqitem.HRESETn)begin
			h_seqitem.HRESP=0;
		end
		else begin
			if(TEMP_ADDR > 1023)begin
				if(error_count==1)begin
					h_seqitem.HRESP=1;
					h_seqitem.HREADY=1;
					error_count=0;
				end
				else begin
					h_seqitem.HRESP=1;        
					h_seqitem.HREADY=0;
					error_count++;
				end

			end
		end

	endtask



  
endclass


