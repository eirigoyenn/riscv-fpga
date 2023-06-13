<<<<<<< HEAD
module alu
(
 input wire [31:0] busA,
 input wire [31:0] busB,
 input wire [2:0] funct3,
 input wire [6:0] funct7,
 input wire [6:0] op,
 output reg [31:0] busC
 );
 
	initial begin
		 busC = 32'h00000000;  // Inicialización de registro 0 32'h00000000
		 
	end
	 
	always @(*)
	begin
		case (op)
			7'b0000011:  busC = busA; // le pongo busA momentaneo para chequear funcionamiento
			7'b0000111:  busC = 1;
			7'b0001011:  busC = busA + busB;
			7'b0001111:  busC = busA - busB;
			7'b0010011:  busC = busA + 1;
			7'b0010111:  busC = busA - 1;
			7'b0100011:  busC = busA;		
			7'b0100111:  busC = busB;		
			default :    busC = 0;
		endcase 
	end
=======
`include "util.v"

module alu (
    input wire [31:0] rs1,
    input wire [31:0] rs2,
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [31:0] imm,
    input wire [31:0] PC,
    output wire [31:0] rd,
    output wire zero, neg, take_branch,
    output wire [31:0] n_PC
);

//    reg [6:0] op;
    reg [31:0] out_reg = 0;
    reg [6:0] funct7;
    reg [31:0] abs_aux1, abs_aux2, new_PC;
    reg flag = 0;
>>>>>>> fa7639bcfa985d53d744e3fa08c2844f7d0905ec

    always @(*)
    begin
		funct7 = imm[6:0];
        case (opcode)
            //-----REGISTER - IMMEDIATE OP -----
            `OP_IMM: begin
                case(funct3)
                    3'b000: out_reg <= rs1 + imm;      // ADDI
                    3'b010: out_reg <= (rs1 < imm) ? 1 : 0;   // SLTIU
                    3'b011: begin                        // SLTI
                        // Valor absoluto de rs1
                        abs_aux1 = (rs1[31] == 1'b1) ? -rs1 : rs1;
                        // Valor absoluto de imm
                        abs_aux2 = (imm[31] == 1'b1) ? -imm : imm;
                        // Comparo al revés. Si imm es 1, el resultado es 1 si rs1 es cero
                        out_reg <= (abs_aux1 > abs_aux2) ? 1 : 0;
                    end
                    3'b111: out_reg <= rs1 & imm;        // ANDI
                    3'b110: out_reg <= rs1 | imm;        // ORI
                    3'b100: out_reg <= rs1 ^ imm;        // XORI
                    3'b001: out_reg <= rs1 << imm[4:0];  // SLLI
                    3'b101: begin                      // SRLI, SRAI
                        case(imm[11:5])
                            7'b0000000: out_reg <= rs1 >> imm[4:0];    // SRLI
                            7'b0100000: out_reg <= rs1 >>> imm[4:0];   // SRAI
                            default: out_reg <= 0;
                        endcase
                    end
                    default: out_reg <= 0;
                endcase
            end
            `LUI: out_reg <= imm;                      // LUI
            `AUIPC: new_PC <= PC + imm;                // AUIPC
            //---- REGISTER - REGISTER OP ----
            `OP: begin
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            7'b0000000: out_reg <= rs1 + rs2;     // ADD
                            7'b0100000: out_reg <= rs1 - rs2;     // SUB
                            default: out_reg <= 0;
                        endcase
                    end
                    3'b010: out_reg <= (rs1 < rs2) ? 1 : 0;       // SLTU
                    3'b011: begin                              // SLT
                        // Valor absoluto de rs1
                        abs_aux1 = (rs1[31] == 1'b1) ? -rs1 : rs1;
                        // Valor absoluto de rs2
                        abs_aux2 = (rs2[31] == 1'b1) ? -rs2 : rs2;
                        // Comparo al revés. Si rs2 es 1, el resultado es 1 si rs1 es cero
                        out_reg <= (abs_aux1 > abs_aux2) ? 1 : 0;
                    end
                    3'b111: out_reg <= rs1 & rs2;             // AND
                    3'b110: out_reg <= rs1 | rs2;             // OR
                    3'b100: out_reg <= rs1 & rs2;             // XOR
                    3'b001: out_reg <= rs1 << rs2[4:0];       // SLL
                    3'b101: begin                            // SRL, SRA
                        case(imm[11:5])
                            7'b0000000: out_reg <= rs1 >> rs2[4:0];   // SRL
                            7'b0100000: out_reg <= rs1 >>> rs2[4:0];  // SRA
                            default: out_reg <= 0;
                        endcase
                    end
                    default: out_reg <= 0;
                endcase
            end
            //REVISAR TEMA SALTOS
            `JAL: new_PC <= PC + imm + 4;              // JAL
            `JALR: new_PC <= rs1 + imm + 4;            // JALR
            `BRANCH: begin
                case(funct3)
                    3'b000: begin                      // BEQ
                        if (rs1 == rs2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    3'b001: begin                     // BNE
                        if (rs1 != rs2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    3'b100: begin                     // BLTU
                        if (rs1 < rs2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    3'b110: begin                            // BLT
                        // Valor absoluto de rs1
                        abs_aux1 = (rs1[31] == 1'b1) ? -rs1 : rs1;
                        // Valor absoluto de rs2
                        abs_aux2 = (rs2[31] == 1'b1) ? -rs2 : rs2;
                        // Comparo al revés. Si rs2 es 1, el resultado es 1 si rs1 es cero
                        if (abs_aux1 > abs_aux2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    3'b101: begin                            // BGE
                        if (rs1 >= rs2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    3'b111: begin
                        // Valor absoluto de rs1
                        abs_aux1 = (rs1[31] == 1'b1) ? -rs1 : rs1;
                        // Valor absoluto de rs2
                        abs_aux2 = (rs2[31] == 1'b1) ? -rs2 : rs2;
                        // Comparo al revés. Si rs2 es 1, el resultado es 1 si rs1 es cero
                        if (abs_aux1 <= abs_aux2) begin
                            new_PC <= PC + imm;
                            flag <= 1;
                        end else
                            flag <= 0;
                    end
                    default: out_reg <= 0;
                endcase
            end
            `LOAD, `STORE: out_reg <= rs1 + imm;        // LOAD, STORE
            default: out_reg <= 0;
        endcase
    end
	 
	 
    assign rd = out_reg;
    assign zero = (rs1 == rs2);
    assign neg = (rs1 < rs2);
    assign n_PC = new_PC;
    assign take_branch = flag;
 
endmodule

