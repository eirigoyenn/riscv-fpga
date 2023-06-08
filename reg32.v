module reg32
(
 input[31:0] d,
 input clk, //hay que borrarlo
 input nreset,
 input ena,
 output [31:0] qo
 );

	reg[31:0] q;
	wire reset;
	
	assign reset = ~nreset;
 
	always @(*) begin
		if (reset) begin
			q = 0;
		end
		else if (ena) begin
			q = d;
		end
	end

	assign qo = q;


endmodule