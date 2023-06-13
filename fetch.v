module fetch
(
 input wire[31:0] PCin,
 input wire clk,
 input wire ena,
 output wire [31:0] memAddress
 );
	
	reg[31:0] currPC;
	
	
	initial begin 
		currPC = 32'h00000000;
	end
	
	always @(posedge clk) begin
			if (ena) begin
				currPC = PCin;
			end
	end
	
	assign memAddress = currPC;


endmodule