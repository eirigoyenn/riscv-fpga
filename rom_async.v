module rom_async(
  input wire [7:0] address,
  input wire one_byte,
  output wire [31:0] q
);

  reg [31:0] q0;
  reg [7:0] memory [255:0]; 
  initial begin
    $readmemh("rominit.hex", memory);
  end
  
	always @ (*) begin 
	
	if(one_byte == 1) begin 
		 q0 = {24'h0000000 , memory[address]};
   end
   else begin
		 q0 = {memory[address+3],memory[address+2],memory[address+1],memory[address]};
   end
	
	end
 
  assign q = q0;
endmodule