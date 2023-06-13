module ram_async(
  input wire [7:0] address,
  input wire [2:0] bytes_,
  input wire [31:0] wBus,
  input wire write_,
  input wire signed_,
  output wire [31:0] q
);

	reg [31:0] q0;
	reg [7:0] memory [255:0]; 
	//initial begin
		//$readmemh("raminit.hex", memory);
	//end
  
	always @ (*) begin 
	
		if (write_) begin  // Si quiero escribir (no se puede escribir el registro 0)
			memory[address] <= wBus;  // Escritura en el registro seleccionado
		end
		else begin
			case(bytes_)
				
				3'b01: begin
							if(signed_ == 1) begin 
								q0 = {{24{memory[address][7]}} , memory[address]};
							end
							else begin
								q0 = {24'h000000 , memory[address]};
							end
						end
				3'b010: begin
							if(signed_ == 1) begin 
								q0 = {{16{memory[address+1][7]}} , memory[address+1], memory[address]};
							end
							else begin
								q0 = {16'h0000 , memory[address]};
							end
						end
				3'b100: begin
								q0 = {memory[address+3],memory[address+2],memory[address+1],memory[address]};
						end
				default : q0 = 32'h00000000;
			endcase
		end
	end
 
	assign q = q0;
endmodule