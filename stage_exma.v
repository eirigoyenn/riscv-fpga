module stage_exma
(
 input wire[31:0] busc_in,
 input wire[31:0] imm_in,
 input wire[31:0] pc_in,
 input wire clk,
 input wire ena_exma,
 input wire [4:0] rd_in,
 input wire[2:0] funct3_in,
 input wire[6:0] op_in,
 input wire[31:0] busb_in,
 output wire[31:0] busc_out,
 output wire[31:0] imm_out,
 output wire[31:0] pc_out,
 output wire [4:0] rd_out,
 output wire[2:0] funct3_out,
 output wire[6:0] op_out,
 output wire[31:0] busb_out
 );
	
	reg[31:0] busc,pc,imm,busb;
	reg[4:0] rd;
	reg[2:0] funct3;
	reg[6:0] op;
	
	
	initial begin 
		busc = 32'h00000000;
		pc = 32'h00000000;
		imm = 32'h00000000;
		funct3 =3'b000;
		op =7'b0000000;
		busb = 32'h00000000;
	end
	
	always @(posedge clk) begin
			if (ena_exma) begin
				busc = busc_in;
				pc = pc_in;
				imm = imm_in;
				rd=rd_in;
				funct3 = funct3_in;
				op =op_in;
				busb = busb_in;
			end
	end
	
	assign busc_out = busc;
	assign pc_out = pc;
	assign imm_out = imm;
	assign rd_out = rd;
	assign funct3_out = funct3;
	assign op_out =op;
	assign busb_out = busb;


endmodule