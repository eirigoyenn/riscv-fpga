module stage_idex
(
 input wire[31:0] busa_in,
 input wire[31:0] busb_in,
 input wire[2:0] funct3_in,
 input wire[31:0] imm_in,
 input wire[6:0] op_in,
 input wire[31:0] pc_in,
 input wire clk,
 input wire ena_idex,
 input wire [4:0] rd_in,
 input wire ras_ena_in,
 output wire[31:0] busa_out,
 output wire[31:0] busb_out,
 output wire[2:0] funct3_out,
 output wire[31:0] imm_out,
 output wire[6:0] op_out,
 output wire[31:0] pc_out,
 output wire [4:0] rd_out,
 output wire ras_ena_out
 );
	
	reg[31:0] busa,busb,pc;
	reg[2:0] funct3;
	reg[6:0] op;
	reg[31:0] imm;
	reg[4:0] rd;
	reg ras_ena;
	
	
	initial begin 
		busa = 32'h00000000;
		busb = 32'h00000000;
		pc = 32'h00000000;
		funct3 =3'b000;
		imm = 32'h00000000;
		op =7'b0000000;
		rd = 5'b00000;
		ras_ena = 1'b0;
	end
	
	always @(posedge clk) begin
			if (ena_idex) begin
				busa = busa_in;
				busb = busb_in;
				pc = pc_in;
				funct3 = funct3_in;
				imm = imm_in;
				op =op_in;
				rd=rd_in;
				ras_ena = ras_ena_in;
			end
			else begin
				busa = 32'h00000000;
				busb = 32'h00000000;
				pc = 32'h00000000;
				funct3 =3'b000;
				imm = 32'h00000000;
				op =7'b0000000;
				rd = 5'b00000;
				ras_ena = 1'b0;
			end
	end
	
	assign busa_out = busa;
	assign busb_out = busb;
	assign pc_out = pc;
	assign funct3_out = funct3;
	assign imm_out = imm;
	assign op_out =op;
	assign rd_out = rd;
	assign ras_ena_out = ras_ena;


endmodule