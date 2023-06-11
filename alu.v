`include "util.v"

module alu
(
 input wire [31:0] rs1,
 input wire [31:0] rs2,
 input wire [3:0] opcode,
 input wire [2:0] funct3,
 input wire [31:0] imm,
 input wire [31:0] PC,
 output wire [31:0] rd,
 output wire zero, neg, take_branch,
 output wire [31:0] new_PC
 );

reg [31:0] out_reg;
reg [6:0] funct7 = imm[7:0];
reg [31:0] abs_aux1, abs_aux2;

assign rd = out_reg;
assign zero = (rs1 == rs2);
assign neg = (rs1 < rs2);

always @(*)
take_branch = 0;
begin
	case (opcode)
	//-----REGISTER - IMMEDIATE OP -----
		`OP_IMM: begin
			case(funct3)
				3'b000: begin		//ADDI
					out_reg = rs1 + imm;
				end
				3'b010: begin 		//SLTI
				//REVISAR TEMA SIGNADO O NO SIGNADO
					if(rs1 < imm)
						out_reg = 1;
					else
						out_reg = 0;
				end
				3'b011: begin 		//SLTIU
					//Valor absoluto de rs1
					if (rs1[31] == 1'b1)
						abs_aux1 = -rs1;
					else
						abs_aux1 = imm;
					//Valr absoluto de imm
					if (imm[31] == 1'b1)
						abs_aux2 = -imm;
					else
						abs_aux2 = imm;
					//Comparo al reves. Si imm es 1, el resultado es 1 si rs1 es cero
					if(abs_aux1 > abs_aux2)
						out_reg = 1;
					else
						out_reg = 0;
				end
				3'b111: begin 		//ANDI
					out_reg = rs1 & imm;
				end
				3'b110: begin 		//ORI
					out_reg = rs1 | imm;
				end
				3'b100: begin 		//XORI
					out_reg = rs1 ^ imm;
				end
				3'b001: begin 		//SLLI
					out_reg = rs1 << imm[4:0];
				end
				3'b101: begin 	
					case(imm[11:5])
						7'b0000000: begin	//SRLI
							out_reg = rs1 >> imm[4:0];
						end
						7'b0100000: begin	//SRAI
							out_reg = rs1 >>> imm[4:0];
						end
					endcase
				end
			endcase
		end
		`LUI:  begin				//LUI
			out_reg = imm;
		end
		`AUIPC:  begin				//AUIPC
			// EN las especificaciones de RISC dice que se guarda en un registro...
			// creo que conviene hacer cmo dice el libro que tiene una salida aparte para el PC
			new_PC = PC + imm;
		end
	//---- REGISTER - REGISTER OP ----
		`OP:  begin
			case(funct3)
				3'b000: begin
					case(funct7)
						7'b0000000: begin	//ADD
							out_reg = rs1 + rs2;
						end
						7'b0100000: begin	//SUB
							out_reg = rs1 - rs2;
						end
					endcase
				end
				3'b010: begin 	//SLT
					if(rs1 < rs2)
						out_reg = 1;
					else
						out_reg = 0;
				end
				3'b011: begin 	//SLTU
					//Valor absoluto de rs1
					if (rs1[31] == 1'b1)
						abs_aux1 = -rs1;
					else
						abs_aux1 = imm;
					//Valr absoluto de rs2
					if (imm[31] == 1'b1)
						abs_aux2 = -rs2;
					else
						abs_aux2 = rs2;
					//Comparo al reves. Si rs2 es 1, el resultado es 1 si rs1 es cero
					if(abs_aux1 > abs_aux2)
						out_reg = 1;
					else
						out_reg = 0;
				end
				3'b111: begin 	//AND
					out_reg = rs1 & rs2;
				end
				3'b110: begin 	//OR
					out_reg = rs1 | rs2;
				end
				3'b100: begin 	//XOR
					out_reg = rs1 & rs2;
				end
				3'b001: begin 	//SLL
					out_reg = rs1 << rs2[4:0];
				end
				3'b101: begin
					case(imm[11:5])
						7'b0000000: begin	//SRL
							out_reg = rs1 >> rs2[4:0];
						end
						7'b0100000: begin	//SRA
							out_reg = rs1 >>> rs2[4:0];
						end
					endcase
				end
			endcase
		end	
		//REVISAR TEMA SALTOS
		`JAL: begin
			//REVISAR
			new_PC = PC + imm + 4;
		end
		`JALR: begin
			//REVISAR
			new_PC = rs1 + imm + 4;
		end
		`BRANCH: begin
			case(funct3)
				3'b000: begin	//BEQ
					if(rs1 == rs2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
				3'b001: begin	//BNE
					if(rs1 != rs2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
				3'b100: begin	//BLT
					if(rs1 < rs2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
				3'b110: begin 	//BLTU
					//Valor absoluto de rs1
					if (rs1[31] == 1'b1)
						abs_aux1 = -rs1;
					else
						abs_aux1 = imm;
					//Valr absoluto de rs2
					if (imm[31] == 1'b1)
						abs_aux2 = -rs2;
					else
						abs_aux2 = rs2;
					//Comparo al reves. Si rs2 es 1, el resultado es 1 si rs1 es cero
					if(abs_aux1 > abs_aux2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
				3'b101: begin 	//BGE
					if(rs1 >= rs2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
				3'b111: begin 
					//Valor absoluto de rs1
					if (rs1[31] == 1'b1)
						abs_aux1 = -rs1;
					else
						abs_aux1 = imm;
					//Valr absoluto de rs2
					if (imm[31] == 1'b1)
						abs_aux2 = -rs2;
					else
						abs_aux2 = rs2;
					//Comparo al reves. Si rs2 es 1, el resultado es 1 si rs1 es cero
					if(abs_aux1 <= abs_aux2) begin
						new_PC = PC + imm;
						take_branch = 1;
					end
					else
						take_branch = 0;
				end
		end
		`LOAD, `STORE: begin
			out_reg = rs1 + imm;
		end
	endcase 
end

 
endmodule
