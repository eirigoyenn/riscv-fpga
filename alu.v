`include "util.v"

module alu (
    input wire [31:0] busA,
    input wire [31:0] busB,
    input wire [2:0] funct3,
    input wire [31:0] imm,
    input wire [6:0] opcode,
    input wire [31:0] PCin,
	 input wire ras,
    output wire [31:0] busC,
    output wire take_jmp
);

    reg [31:0] out_reg = 0;
    reg [6:0] funct7;
    reg [31:0] abs_aux1, abs_aux2;
    reg flag = 0;	 

    always @(*)
    begin
	 out_reg = 0;
	 flag = 0;
		funct7 = imm[6:0];
        case (opcode)
            //-----REGISTER - IMMEDIATE OP -----
            `OP_IMM: begin
                case(funct3)
                    3'b000: out_reg <= busA + imm;      // ADDI
                    3'b010: out_reg <= (busA < imm) ? 1 : 0;   // SLTIU
                    3'b011: begin                        // SLTI
                        // Valor absoluto de busA
                        abs_aux1 = (busA[31] == 1'b1) ? -busA : busA;
                        // Valor absoluto de imm
                        abs_aux2 = (imm[31] == 1'b1) ? -imm : imm;
                        // Comparo al revés. Si imm es 1, el resultado es 1 si busA es cero
                        out_reg <= (abs_aux1 > abs_aux2) ? 1 : 0;
                    end
                    3'b111: out_reg <= busA & imm;        // ANDI
                    3'b110: out_reg <= busA | imm;        // ORI
                    3'b100: out_reg <= busA ^ imm;        // XORI
                    3'b001: out_reg <= busA << imm[4:0];  // SLLI
                    3'b101: begin                      // SRLI, SRAI
                        case(imm[11:5])
                            7'b0000000: out_reg <= busA >> imm[4:0];    // SRLI
                            7'b0100000: out_reg <= busA >>> imm[4:0];   // SRAI
                            default: out_reg <= 0;
                        endcase
                    end
                    default: out_reg <= 0;
                endcase
            end
            `LUI: out_reg <= imm;                      // LUI
            `AUIPC: begin						// AUIPC
							out_reg <= 0;
							flag <= 1'b1;
						end				
            //---- REGISTER - REGISTER OP ----
            `OP: begin
                case(funct3)
                    3'b000: begin
                        case(funct7)
                            7'b0000000: out_reg <= busA + busB;     // ADD
                            7'b0100000: out_reg <= busA - busB;     // SUB
                            default: out_reg <= 0;
                        endcase
                    end
                    3'b010: out_reg <= (busA < busB) ? 1 : 0;       // SLTU
                    3'b011: begin                              // SLT
                        // Valor absoluto de busA
                        abs_aux1 = (busA[31] == 1'b1) ? -busA : busA;
                        // Valor absoluto de busB
                        abs_aux2 = (busB[31] == 1'b1) ? -busB : busB;
                        // Comparo al revés. Si busB es 1, el resultado es 1 si busA es cero
                        out_reg <= (abs_aux1 > abs_aux2) ? 1 : 0;
                    end
                    3'b111: out_reg <= busA & busB;             // AND
                    3'b110: out_reg <= busA | busB;             // OR
                    3'b100: out_reg <= busA & busB;             // XOR
                    3'b001: out_reg <= busA << busB[4:0];       // SLL
                    3'b101: begin                            // SRL, SRA
                        case(imm[11:5])
                            7'b0000000: out_reg <= busA >> busB[4:0];   // SRL
                            7'b0100000: out_reg <= busA >>> busB[4:0];  // SRA
                            default: out_reg <= 0;
                        endcase
                    end
                    default: out_reg <= 0;
                endcase
            end
            //REVISAR TEMA SALTOS
            `JAL, `JALR: begin 
                            out_reg <= PCin + 4;              // JAL y JALR. pongo en busC la direccion de retorno
                            flag <= 1'b1;
					    end
            `BRANCH: begin
                case(funct3)
                    3'b000: flag <= (busA == busB) ? 1'b1 : 1'b0;                      // BEQ
                    3'b001: flag <= (busA != busB) ? 1'b1 : 1'b0;                     // BNE
                    3'b100: flag <= (busA < busB) ? 1'b1 : 1'b0;                     // BLTU
                    3'b110: begin                            // BLT
                        // Valor absoluto de busA
                        abs_aux1 = (busA[31] == 1'b1) ? -busA : busA;
                        // Valor absoluto de busB
                        abs_aux2 = (busB[31] == 1'b1) ? -busB : busB;
                        // Comparo al revés. Si busB es 1, el resultado es 1 si busA es cero
                        if (abs_aux1 > abs_aux2) begin
                            flag <= 1'b1;
                        end else
                            flag <= 1'b0;
                    end
                    3'b101: flag <= (busA >= busB) ? 1'b1 : 1'b0;                           // BGE
                    3'b111: begin
                        // Valor absoluto de busA
                        abs_aux1 = (busA[31] == 1'b1) ? -busA : busA;
                        // Valor absoluto de busB
                        abs_aux2 = (busB[31] == 1'b1) ? -busB : busB;
                        // Comparo al revés. Si busB es 1, el resultado es 1 si busA es cero
                        if (abs_aux1 <= abs_aux2) begin
                            flag <= 1'b1;
                        end else
                            flag <= 1'b0;
                    end
                    default: out_reg <= 0;
                endcase
            end
				//-------- MEMORY --------
            `LOAD, `STORE: out_reg <= busA + imm;        // LOAD, STORE
            default: out_reg <= 0;
        endcase
    end
	 
	 
    assign busC = out_reg;
    assign take_jmp = (ras? 0:flag);
 
endmodule

