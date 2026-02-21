

task automatic global_s(ref bit [4:0]burst_length,bit[31:0]queue[$],sequence_item req);

	integer wrap_bndry;  
	integer high_bndry;  
  bit [31:0]temp;      
	
	if(req.HBURST=='d2 )
		burst_length=4;
	else if(req.HBURST=='d4 )
		burst_length=8;
	else if(req.HBURST=='d6) 
		burst_length=16;

	
		if(req.HBURST=='d2 ||req.HBURST=='d4 ||req.HBURST=='d6)begin
				if(req.HTRANS=='d2)begin//{
					wrap_bndry= (((req.HADDR/((2**req.HSIZE )* burst_length))) *((2**req.HSIZE) * burst_length));
					high_bndry = (wrap_bndry +((2**req.HSIZE) * burst_length));
					$display("******************wrap_bndry===%d high_bndry=%d====",wrap_bndry,high_bndry);
				end
				
	
		end
		temp=req.HADDR;
    for(int i=0;i<(burst_length);i++)begin//{
      if(temp>=high_bndry)begin//{
        temp=wrap_bndry;
        $display($time,"\t UPPER ------------- HTRANS=%0D  HADDR=%0D  HSIZE=%0D TEMP=%0D",req.HTRANS,req.HADDR,req.HSIZE,temp);
        queue.push_back(temp);  //---- or try lb
        temp=temp+(2**req.HSIZE);
      end//}
      else begin//{
        queue.push_back(temp);
        $display($time,"\t NORMAL ------------- HTRANS=%0D  HADDR=%0D  HSIZE=%0D TEMP=%0D",req.HTRANS,req.HADDR,req.HSIZE,temp);
        temp=temp+(2**req.HSIZE);
      end//}
      
    end//}
    	
						
endtask



task automatic address(ref bit[4:0]burst_length,sequence_item req);
	
		$display("valueeeeeeeeeeee req nburst %d---",req.HBURST);
	
	if( req.HBURST =='d3)
		burst_length=4;
	else if( req.HBURST=='d5)
		burst_length=8;
	else if( req.HBURST =='d7)
		burst_length=16;

endtask





class SEQUENCE extends uvm_sequence #(sequence_item);
  
  `uvm_object_utils(SEQUENCE)
  
  function new(string name="SEQUENCE");
    super.new(name);
  endfunction
  
  
  task body;
    req=sequence_item::type_id::create("req");
    
		start_item(req);
    req.randomize with {HRESETn==0;HWDATA==10;};
    finish_item(req);
    
		start_item(req);
    req.randomize with {HRESETn==1;HTRANS==2'b10;HWRITE==1;HADDR=='d45;HSELx==1;HSIZE=='d2;HBURST==0;};
    finish_item(req);
    
    start_item(req);
		req.randomize with {HRESETn==1;HTRANS==2'b10;HWRITE==1;HADDR=='d45;HSELx==1;HSIZE=='d2;HBURST==0;HWDATA=='h12345678;};
    finish_item(req);

  endtask
  


endclass





class INCR4 extends SEQUENCE;
  
  `uvm_object_utils(INCR4)
   function new(string name="INCR4");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;

		bit [31:0]temp;
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==3;});
	

		address(burst_length,req);
		temp=req.HADDR;
		$display("valueeeeeeeeeeee burstlength %d---",burst_length);
		repeat(burst_length-1)begin
		  temp=temp+(2**req.HSIZE);
			`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR==temp;HBURST==3;});
		end
			
		
endtask

endclass










class INCR8 extends SEQUENCE;
  
  `uvm_object_utils(INCR8)
   function new(string name="INCR8");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;

		bit [31:0]temp; 
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==5;});
	

		address(burst_length,req);
		temp=req.HADDR;
		$display("valueeeeeeeeeeee burstlength %d---",burst_length);
		repeat(burst_length-1)begin
		  temp=temp+(2**req.HSIZE);
			`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR==temp;HBURST==5;});
		end
			
		
endtask

endclass




class INCR16 extends SEQUENCE;
  
  `uvm_object_utils(INCR16)
   function new(string name="INCR16");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;

		bit [31:0]temp;
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==7;});
	

		address(burst_length,req);
		temp=req.HADDR;
		$display("valueeeeeeeeeeee burstlength %d---",burst_length);
		repeat(burst_length-1)begin
		  temp=temp+(2**req.HSIZE);
			`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR==temp;HBURST==7;});
		end
			
		
endtask

endclass









class wrap4 extends SEQUENCE;
  
  `uvm_object_utils(wrap4)
   function new(string name="");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;
	 bit[31:0]queue[$]; 
	 bit [31:0]temp;    
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==2;});
	

		global_s(burst_length,queue,req);
		temp=queue.pop_front;

			$display("valueeeeeeeee queue %p",queue);
		repeat(burst_length)begin
			temp=queue.pop_front;
			$display("valueeeeeeeee temp %D",temp);
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==2;});
		end
	
		
		`uvm_do_with(req,{HRESETn==0;HTRANS=='D2;HWRITE==0;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==2;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==0;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==2;});
	

		global_s(burst_length,queue,req);
		temp=queue.pop_front;

			$display("valueeeeeeeee queue %p",queue);
		repeat(burst_length-1)begin
			temp=queue.pop_front;
			$display("valueeeeeeeee temp %D",temp);
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==2;});
		end

		
endtask

endclass



class wrap8 extends SEQUENCE;
  
  `uvm_object_utils(wrap8)
   function new(string name="");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;
	 bit[31:0]queue[$]; 
	 bit [31:0]temp;    
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==4;});
	

		global_s(burst_length,queue,req);
		
			$display("valueeeeeeeee queue %p",queue);
		repeat(burst_length)begin
			temp=queue.pop_front;
			$display("valueeeeeeeee temp %D",temp);
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==4;});
		end
			
		
endtask

endclass



class wrap8_wait extends SEQUENCE;
  
  `uvm_object_utils(wrap8_wait)
   function new(string name="wrap8_wait");
    super.new(name);
  endfunction
  
  
  task body;
	 bit [4:0]burst_length;
	 bit[31:0]queue[$]; 
	 bit [31:0]temp;    
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==4;});
	

		global_s(burst_length,queue,req);
		
			$display("valueeeeeeeee queue %p",queue);
		
		for(int i=0;i<=burst_length+1;i++)begin
			if(i==6 ||i==7)begin
				if(i==6) temp=queue.pop_front; 			
				`uvm_do_with(req,{HRESETn==1;HTRANS=='D1;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==4;});		
			end
			else begin
				if(i!=8)temp=queue.pop_front;
				$display("valueeeeeeeee temp %D",temp);
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==4;});
			end
		end
			
		
	endtask

endclass





class wrap16 extends SEQUENCE;
  
  `uvm_object_utils(wrap16)
   function new(string name="");
    super.new(name);
  endfunction
  
  
  task body;
	 
	 bit [4:0]burst_length;
	 bit[31:0]queue[$]; 
	 bit [31:0]temp;    
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR=='d50;HBURST==6;});
	

		global_s(burst_length,queue,req);
		
			$display("valueeeeeeeee queue %p",queue);
		repeat(burst_length-1)begin
			temp=queue.pop_front;
			$display("valueeeeeeeee temp %D",temp);
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d1;HSELx==1;HADDR==temp;HBURST==6;});
		end
			
	endtask

endclass















class INCR extends SEQUENCE;
  
  `uvm_object_utils(INCR)
  
  function new(string name="INCR");
    super.new(name);
  endfunction
  
  
  task body;
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d44;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d48;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d52;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d56;HBURST==1;});


		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d60;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d64;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d68;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d72;HBURST==1;});
		

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D1;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d76;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D0;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d76;HBURST==1;});


	//------------------------------------------------------------------------------------------------------------------


		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d44;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d48;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d52;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d56;HBURST==1;});


		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d60;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d64;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d68;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d72;HBURST==1;});
		

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D1;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d76;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D0;HWRITE==0;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d76;HBURST==1;});



  endtask
  


endclass




class error_resp extends SEQUENCE;
  
  `uvm_object_utils(error_resp)
  
  function new(string name="error_resp");
    super.new(name);
  endfunction
  
  
  task body;
    req=sequence_item::type_id::create("req");
    start_item(req);
    req.randomize() with {HRESETn==0;};
    finish_item(req);

		`uvm_do_with(req,{HRESETn==1;HTRANS=='D2;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d40;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d44;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d1052;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h87654321;HSIZE=='d2;HSELx==1;HADDR=='d52;HBURST==1;});
		`uvm_do_with(req,{HRESETn==1;HTRANS=='D3;HWRITE==1;HWDATA=='h12345678;HSIZE=='d2;HSELx==1;HADDR=='d56;HBURST==1;});


  endtask
  


endclass

