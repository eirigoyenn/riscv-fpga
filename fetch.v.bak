module fetch
(
 input[31:0] readPC,
 input clk,
 input nreset,
 input ena,
 output [31:0] writePC,
 output[31:0] memAddress
 );

	reg[31:0] q, address;
	wire reset;
	
	assign reset = ~nreset;
 
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			q <= 0;	//Al reset, vuelve el PC a cero
		end
		else if (clk && ena) begin
			address <= readPC;
			q <= readPC + 4;	//Le suma 4 a cada pulso de clk
		end
	end
	
	assign memAddress = address;
	assign writePC = q;


endmodule