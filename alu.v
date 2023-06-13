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

 
endmodule
