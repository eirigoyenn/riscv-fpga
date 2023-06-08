module alu
(
 input[31:0] busA,
 input[31:0] busB,
 input[6:0] op,
 input[2:0] funct3,
 input[6:0] funct7,
 output reg [31:0] busC
 );

 
always @(busA, busB, op)
begin
	case (op)
		4'b0000:  busC = 0;
		4'b0001:  busC = 1;
		4'b0010:  busC = busA + busB;
		4'b0011:  busC = busA - busB;
		4'b0100:  busC = busA + 1;
		4'b0101:  busC = busA - 1;
		4'b1000:  busC = busA;		
		4'b1001:  busC = busB;		
	endcase 
end

 
endmodule
