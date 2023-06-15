`include "util.v"

module mem_control
(
	input wire [6:0] opcode_MA,
	input wire [2:0] funct3_MA,
	output wire [2:0] num_bytes_MA,
	output wire [1:0] wrn_MA,			//Write(10), read (01), none (00)
	output wire signado_MA
);
	
	reg[1:0] wrn;
	reg[2:0] num_bytes;
	reg signado;
	
	always @(*) begin
		case (opcode_MA)
			`STORE: begin
					wrn = 2'b10;
					signado = ~funct3_MA[2];
					case(funct3_MA)
						3'b000: begin
									num_bytes = funct3_MA << 1;
								end
						3'b001: begin
									num_bytes = funct3_MA << 1;
								end
						3'b010: begin
									num_bytes = funct3_MA << 1;
								end
						default : num_bytes = 3'b000;
					endcase
				end
			
			`LOAD: begin
					wrn = 2'b01;
					signado = ~funct3_MA[2];
					case(funct3_MA)
						3'b000: begin
									num_bytes = funct3_MA << 1;
								end
						3'b001: begin
									num_bytes = funct3_MA << 1;
								end
						3'b010: begin
									num_bytes = funct3_MA << 1;
								end
						default : num_bytes = 3'b000;
					endcase
				end
			default: begin
						wrn=2'b00;
						signado = 1'b0;
						num_bytes= 3'b000;
						end
		endcase
	end
	
	assign signado_MA = signado;
	assign wrn_MA = wrn;
	assign num_bytes_MA = num_bytes;
endmodule