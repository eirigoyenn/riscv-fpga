module fetch
(
 input wire[31:0] PC_in,
 input wire clk,
 input wire ena,
 output wire [31:0] PC_out,
 output wire [31:0] memAddress
 );

	reg[31:0] q;
	
	always @(posedge clk) begin
		if (ena) begin
			q <= PC_in + 4;	//Le suma 4 a cada pulso de clk
		end
	end
	
	assign memAddress = PC_in;
	assign PC_out = q;


endmodule