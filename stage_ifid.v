module stage_ifid
(
 input wire[31:0] inst_in,
 input wire[31:0] pc_in,
 input wire clk,
 input wire ena_ifid,
 output wire[31:0]inst_out,
 output wire[31:0] pc_out
 );
	
	reg[31:0] inst,pc;
	
	
	initial begin 
		inst = 32'h00000000;
		pc = 32'h00000000;
	end
	
	always @(posedge clk) begin
			if (ena_ifid) begin
				inst = inst_in;
				pc = pc_in;
			end
	end
	
	assign inst_out = inst;
	assign pc_out = pc;


endmodule