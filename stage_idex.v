module stage_idex
(
 input wire[31:0] busa_in,
 input wire[31:0] busb_in,
 input wire[2:0] funct3_in,
 input wire[6:0] funct7_in,
 input wire[11:0] imm_in,
 input wire[6:0] op_in,
 input wire[31:0] pc_in,
 input wire clk,
 input wire ena_idex,
 input wire [4:0] rd_in,
 output wire[31:0] busa_out,
 output wire[31:0] busb_out,
 output wire[2:0] funct3_out,
 output wire[6:0] funct7_out,
 output wire[11:0] imm_out,
 output wire[6:0] op_out,
 output wire[31:0] pc_out,
 output wire [4:0] rd_out
 );
	
	reg[31:0] busa,busb,pc;
	reg[2:0] funct3;
	reg[6:0] funct7,op;
	reg[11:0] imm;
	reg[4:0] rd;
	
	
	initial begin 
		busa = 32'h00000000;
		busb = 32'h00000000;
		pc = 32'h00000000;
		funct3 =3'b000;
		funct7 = 7'b0000000;
		imm = 12'b000000000000;
		op =7'b0000000;
		rd = 5'b00000;
	end
	
	always @(posedge clk) begin
			if (ena_idex) begin
				busa = busa_in;
				busb = busb_in;
				pc = pc_in;
				funct3 = funct3_in;
				funct7 = funct7_in;
				imm = imm_in;
				op =op_in;
				rd=rd_in;
			end
	end
	
	assign busa_out = busa;
	assign busb_out = busb;
	assign pc_out = pc;
	assign funct3_out = funct3;
	assign funct7_out = funct7;
	assign imm_out = imm;
	assign op_out =op;
	assign rd_out = rd;


endmodule