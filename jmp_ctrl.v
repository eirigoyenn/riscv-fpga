`include "util.v"

module jmp_ctrl (
    input wire [6:0] opcode,
    input wire [31:0] rs1, imm, PCin,
    output wire [31:0] PC_jmp
);

    reg [31:0] new_PC;

    always @(*)
    begin
        case (opcode)
            //REVISAR TEMA SALTOS
            `JAL: new_PC <= PCin + imm ;              // JAL	La ALU pone en rd la direccion de retorno
            `JALR: new_PC <= rs1 + imm ;            // JALR
				`BRANCH: new_PC <= PCin + imm;		// Lo hace para todos los branches y despues la ALU dice si se cumplio o no la condicion
            `AUIPC: new_PC <= PCin + imm;                // AUIPC
				default: new_PC <= 0;
        endcase
    end
	 
    assign PC_jmp = new_PC;
 
endmodule

