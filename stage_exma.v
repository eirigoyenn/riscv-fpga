module stage_exma
(
 input wire[31:0] busc_in,
 input wire[11:0] imm_in,
 input wire[31:0] pc_in,
 input wire clk,
 input wire ena_exma,
 input wire [4:0] rd_in,
 output wire[31:0] busc_out,
 output wire[11:0] imm_out,
 output wire[31:0] pc_out,
 output wire [4:0] rd_out
 );
	
	reg[31:0] busc,pc;
	reg[11:0] imm;
	reg[4:0] rd;
	
	
	initial begin 
		busc = 32'h00000000;
		pc = 32'h00000000;
		imm = 12'b000000000000;
	end
	
	always @(posedge clk) begin
			if (ena_exma) begin
				busc = busc_in;
				pc = pc_in;
				imm = imm_in;
				rd=rd_in;
			end
	end
	
	assign busc_out = busc;
	assign pc_out = pc;
	assign imm_out = imm;
	assign rd_out = rd;


endmodule