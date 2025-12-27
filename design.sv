

module ahb_slave #(
    parameter AW = 8,                 
    parameter DW = 32,                
    parameter MEM_DEPTH = 256,        
    parameter WAIT_CYCLES = 0         
)(
    input  logic             clk,
    input  logic             resetn,     
    input  logic [AW-1:0]    haddr,      
    input  logic             hwrite,     
    input  logic [2:0]       hsize,      
    input  logic [2:0]       hburst,     
    input  logic [3:0]       hprot,      
    input  logic [DW-1:0]    hwdata,     
    input  logic             hsel,       
    input  logic             hready,  //master
    output logic [DW-1:0]    hrdata,     
    output logic             hready_out, //from slave
    output logic [1:0]       hresp       
);

    
    localparam OKAY  = 2'b00;
    localparam ERROR = 2'b01;
    logic [DW-1:0] mem [0:MEM_DEPTH-1];
    integer i;
    integer wait_cnt;
    always_ff @(negedge resetn or posedge clk) begin
        if (!resetn) begin
            hready_out <= 1'b1;
            hresp      <= OKAY;
            hrdata     <= '0;
            wait_cnt   <= 0;
            for (i = 0; i < MEM_DEPTH; i++) mem[i] <= '0;
        end
        else begin
           
            hready_out <= 1'b1;
            hresp      <= OKAY;

            if (hsel && hready) begin
               
                if (WAIT_CYCLES != 0 && wait_cnt < WAIT_CYCLES) begin
                    hready_out <= 1'b0;
                    wait_cnt   <= wait_cnt + 1;
                end else begin
                    wait_cnt <= 0;

                    if (hburst inside {3'b000, 3'b001, 3'b010}) begin
                        if (hwrite) begin
                            mem[haddr] <= hwdata;
                        end else begin
                            hrdata <= mem[haddr];
                        end
                    end else begin
                        hresp <= ERROR; 
                    end
                end
            end
        end
    end

  
    `ifdef ASSERT_ON
    property valid_addr;
        @(posedge clk) disable iff (!resetn)
            hsel && hready |-> haddr < MEM_DEPTH;
    endproperty

    assert property (valid_addr)
        else $error("AHB Slave: Address out of range %0d", haddr);
    `endif

endmodule
